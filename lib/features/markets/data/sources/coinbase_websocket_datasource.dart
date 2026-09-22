import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

/// Live prices from the public Coinbase Exchange feed.
///
/// Symbols are UPPER-CASE base assets everywhere ("BTC", never "btc"),
/// matching CoinEntity.symbol, so map lookups in the UI line up.
///
/// v3 fixes:
///  - Bug 1: `await channel.ready` now has a 10-second timeout so a stalled
///    handshake (weak signal, DNS failure) throws instead of hanging forever.
///  - Bug 2: One subscribe message PER product (20ms stagger). A bad/unknown
///    symbol from Coinbase only costs that single product — the other 49 are
///    unaffected and do not need to be re-subscribed.
///  - Bug 3 / 5: A silence watchdog fires every 10 seconds. If no frame has
///    arrived for 20 seconds (impossible under normal conditions when BTC and
///    ETH are ticking), the socket is presumed dead (zombie / half-open TCP)
///    and the connection is rebuilt from scratch. This covers the case where
///    the phone sleeps or switches networks without sending a TCP FIN, which
///    means onDone/onError never fire and the old code waited forever.
class CoinbaseWebSocketDataSource {
  static const String _url = 'wss://ws-feed.exchange.coinbase.com';
  static const Duration _flushInterval = Duration(milliseconds: 500);
  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _watchdogInterval = Duration(seconds: 10);
  static const Duration _maxSilence = Duration(seconds: 20);
  static const Duration _subscribeGap = Duration(milliseconds: 20);

  // Only symbols that can form a valid "<SYM>-USD" product ID.
  // Filters out things like CoinGecko's "bsc-usd" which would become
  // "BSC-USD-USD" and cause an error on every subscribe batch.
  static final RegExp _validSymbol = RegExp(r'^[A-Z0-9]+$');

  // Persistent controller: listeners survive socket reconnects.
  final StreamController<List<TickerUpdateEntity>> _controller =
      StreamController<List<TickerUpdateEntity>>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSubscription;
  Timer? _reconnectTimer;
  Timer? _flushTimer;
  Timer? _watchdog;

  // Every connect attempt gets a new generation. Callbacks from an older
  // generation are ignored, so overlapping connect() calls can't fight over
  // the same socket.
  int _generation = 0;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  DateTime _lastFrameAt = DateTime.now();
  int _framesSinceCheck = 0;
  // Symbols that have sent at least one tick on this connection.
  final Set<String> _seen = <String>{};

  Set<String> _wanted = <String>{};
  final Set<String> _rejected = <String>{}; // symbols Coinbase said are invalid
  final Map<String, TickerUpdateEntity> _pending = <String, TickerUpdateEntity>{};

  Stream<List<TickerUpdateEntity>> get liveTickerStream => _controller.stream;

  /// Idempotent while the socket is up with the same symbols.
  /// Always reconnects when called with a changed symbol set.
  void subscribeToSymbols(List<String> symbols) {
    final next = symbols
        .map((s) => s.toUpperCase())
        .where(_validSymbol.hasMatch)
        .toSet();

    final skipped = symbols.length - next.length;
    if (skipped > 0) {
      _log('skipped $skipped symbols that cannot form a valid Coinbase product');
    }

    final alive = _channel != null || (_reconnectTimer?.isActive ?? false);
    if (alive && setEquals(next, _wanted)) return;
    _wanted = next;
    _connect();
  }

  /// Force a fresh connection — safe to call repeatedly (e.g. on app resume).
  void reconnect() {
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    _connect();
  }

  Future<void> _connect() async {
    if (_isDisposed || _wanted.isEmpty) return;

    final int generation = ++_generation;
    _reconnectTimer?.cancel();
    _teardown();

    _seen.clear();
    _framesSinceCheck = 0;
    _lastFrameAt = DateTime.now();
    _startWatchdog(generation);

    WebSocketChannel? pending;
    try {
      final channel = WebSocketChannel.connect(Uri.parse(_url));
      pending = channel;

      // Bug 1 fix: timeout so a stalled handshake fails instead of hanging
      // forever. Without this, await channel.ready can wait indefinitely on
      // a weak or unstable network.
      await channel.ready.timeout(_connectTimeout);

      if (generation != _generation || _isDisposed) {
        unawaited(channel.sink.close());
        return;
      }

      _channel = channel;
      _wsSubscription = channel.stream.listen(
        (event) => _onMessage(event, generation),
        onError: (Object error) {
          _log('socket error: $error');
          if (generation == _generation) _scheduleReconnect();
        },
        onDone: () {
          _log(
            'socket closed '
            '(code ${channel.closeCode}, reason ${channel.closeReason})',
          );
          if (generation == _generation) _scheduleReconnect();
        },
      );

      _log('connected');
      unawaited(_sendSubscriptions(channel, generation));
    } catch (e) {
      _log('connect failed: $e');
      unawaited(pending?.sink.close());
      if (generation == _generation) _scheduleReconnect();
    }
  }

  void _teardown() {
    final sub = _wsSubscription;
    final channel = _channel;
    _wsSubscription = null;
    _channel = null;
    _watchdog?.cancel();
    _watchdog = null;
    unawaited(sub?.cancel());
    unawaited(channel?.sink.close());
  }

  /// Bug 2 fix: one subscribe message PER product with a small gap between
  /// each. If Coinbase rejects one (e.g. an unlisted altcoin), only that one
  /// product is lost — the rest continue ticking normally. The old single-
  /// batch approach could require multiple round-trips to recover from bad
  /// symbols, and was fragile if those round-trips were interrupted.
  Future<void> _sendSubscriptions(
    WebSocketChannel channel,
    int generation,
  ) async {
    final products = (_wanted.difference(_rejected).toList()..sort())
        .map((s) => '$s-USD')
        .toList();

    try {
      for (final product in products) {
        if (generation != _generation || !identical(channel, _channel)) return;
        channel.sink.add(
          jsonEncode({
            'type': 'subscribe',
            'product_ids': [product],
            'channels': ['ticker'],
          }),
        );
        await Future<void>.delayed(_subscribeGap);
      }
      _log('sent ${products.length} subscribe messages');
    } catch (e) {
      _log('subscribe loop failed: $e');
    }
  }

  /// Bug 3 / 5 fix: periodic watchdog. If no frame arrives for [_maxSilence]
  /// (20s), the socket is treated as a zombie and torn down so a fresh
  /// connection is started. This handles half-open TCP sockets that survive
  /// phone sleep or Wi-Fi↔mobile switches without triggering onDone/onError.
  void _startWatchdog(int generation) {
    _watchdog?.cancel();
    _watchdog = Timer.periodic(_watchdogInterval, (_) {
      if (generation != _generation) return;

      final silence = DateTime.now().difference(_lastFrameAt);
      final expected = _wanted.difference(_rejected).length;
      _log(
        'health: $_framesSinceCheck frames in ${_watchdogInterval.inSeconds}s, '
        '${_seen.length}/$expected products ticking, '
        'rejected=${(_rejected.toList()..sort())}',
      );
      _framesSinceCheck = 0;

      if (silence > _maxSilence) {
        _log('no data for ${silence.inSeconds}s — rebuilding connection');
        _scheduleReconnect();
      }
    });
  }

  void _onMessage(dynamic event, int generation) {
    if (generation != _generation) return;
    _lastFrameAt = DateTime.now();
    _framesSinceCheck++;
    _reconnectAttempts = 0;

    final String text =
        event is String ? event : utf8.decode(event as List<int>);

    final dynamic decoded;
    try {
      decoded = jsonDecode(text);
    } catch (_) {
      _log('unparseable frame: $text');
      return;
    }
    if (decoded is! Map<String, dynamic>) return;

    switch (decoded['type']) {
      case 'ticker':
        _onTicker(decoded);
      case 'subscriptions':
        _log('subscriptions confirmed: ${jsonEncode(decoded['channels'])}');
      case 'error':
        _onServerError(decoded);
    }
  }

  void _onTicker(Map<String, dynamic> data) {
    final productId = data['product_id'];
    final priceText = data['price']?.toString();
    if (productId is! String || priceText == null) return;

    final price = Decimal.tryParse(priceText);
    if (price == null) return;

    final symbol = productId.split('-').first.toUpperCase();
    _seen.add(symbol);

    // The ticker message includes open_24h, so the live 24h % is computable.
    Decimal? change24h;
    final now = double.tryParse(priceText);
    final open = double.tryParse(data['open_24h']?.toString() ?? '');
    if (now != null && open != null && open > 0) {
      change24h = Decimal.parse(
        (((now - open) / open) * 100).toStringAsFixed(2),
      );
    }

    // Buffer and flush in batches so the UI rebuilds at most ~2x per second.
    _pending[symbol] = TickerUpdateEntity(
      symbol: symbol,
      price: price,
      priceChangePercentage24h: change24h,
    );
    _flushTimer ??= Timer(_flushInterval, _flush);
  }

  void _flush() {
    _flushTimer = null;
    if (_isDisposed || _pending.isEmpty) return;
    final batch = _pending.values.toList();
    _pending.clear();
    _controller.add(batch);
  }

  /// Because every product has its own subscribe message, an error only ever
  /// names one product. We remember it so reconnects skip it permanently.
  void _onServerError(Map<String, dynamic> data) {
    _log('SERVER ERROR: ${jsonEncode(data)}');

    final reason = '${data['reason'] ?? data['message']}';
    final match = RegExp(r'\b([A-Z0-9]+)-USD\b').firstMatch(reason);
    if (match != null && _rejected.add(match.group(1)!)) {
      _log('will skip ${match.group(1)}-USD from now on');
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;
    _generation++; // ignore any further callbacks from the dead socket
    _teardown();
    _reconnectTimer?.cancel();

    _reconnectAttempts++;
    // 2s, 4s, 8s, 16s, then 30s cap.
    final seconds = math.min(30, 1 << math.min(_reconnectAttempts, 5));
    _log('reconnecting in ${seconds}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(Duration(seconds: seconds), _connect);
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[CoinbaseWS] $message');
  }

  void dispose() {
    _isDisposed = true;
    _generation++;
    _reconnectTimer?.cancel();
    _flushTimer?.cancel();
    _teardown();
    _controller.close();
  }
}
