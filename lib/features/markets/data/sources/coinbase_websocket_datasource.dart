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
class CoinbaseWebSocketDataSource {
  static const String _url = 'wss://ws-feed.exchange.coinbase.com';
  static const Duration _flushInterval = Duration(milliseconds: 500);

  // Persistent controller: listeners survive socket reconnects.
  final StreamController<List<TickerUpdateEntity>> _controller =
      StreamController<List<TickerUpdateEntity>>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _wsSubscription;
  Timer? _reconnectTimer;
  Timer? _flushTimer;

  // Every connect attempt gets a new generation. Callbacks from an older
  // generation are ignored, so overlapping connect() calls can't fight over
  // the same socket (the old loop used to write to / close each other's channel).
  int _generation = 0;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  Set<String> _wanted = <String>{};
  final Set<String> _rejected = <String>{}; // symbols Coinbase said are invalid
  final Map<String, TickerUpdateEntity> _pending = <String, TickerUpdateEntity>{};

  Stream<List<TickerUpdateEntity>> get liveTickerStream => _controller.stream;

  /// Idempotent: calling it again with the same symbols is a no-op while the
  /// socket is up (or a reconnect is already scheduled).
  void subscribeToSymbols(List<String> symbols) {
    final next = symbols.map((s) => s.toUpperCase()).toSet();
    final alive = _channel != null || (_reconnectTimer?.isActive ?? false);
    if (alive && setEquals(next, _wanted)) return;
    _wanted = next;
    _connect();
  }

  /// Force a fresh connection (safe to call repeatedly).
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

    try {
      final channel = WebSocketChannel.connect(Uri.parse(_url));
      // Throws here if the handshake fails, and guarantees the socket is open
      // before we send anything.
      await channel.ready;

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
          _log('socket closed (code ${channel.closeCode}, reason ${channel.closeReason})');
          if (generation == _generation) _scheduleReconnect();
        },
      );

      _sendSubscribe(channel);
    } catch (e) {
      _log('connect failed: $e');
      if (generation == _generation) _scheduleReconnect();
    }
  }

  void _teardown() {
    final sub = _wsSubscription;
    final channel = _channel;
    _wsSubscription = null;
    _channel = null;
    unawaited(sub?.cancel());
    unawaited(channel?.sink.close());
  }

  /// One subscribe message for every valid product. Coinbase replies with an
  /// `error` message naming a product it doesn't know; _onServerError drops
  /// that product and resubscribes with the rest.
  void _sendSubscribe(WebSocketChannel channel) {
    final products =
        _wanted.difference(_rejected).map((s) => '$s-USD').toList()..sort();
    if (products.isEmpty) return;

    _log('subscribing to ${products.length} products');
    channel.sink.add(
      jsonEncode({
        'type': 'subscribe',
        'product_ids': products,
        // heartbeat is for gap detection, not keep-alive; ticker traffic is enough.
        'channels': ['ticker'],
      }),
    );
  }

  void _onMessage(dynamic event, int generation) {
    if (generation != _generation) return;
    _reconnectAttempts = 0;

    final String text = event is String ? event : utf8.decode(event as List<int>);

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

    // The ticker message includes open_24h, so the live 24h % is computable.
    // (Plain doubles here just to keep the arithmetic simple.)
    Decimal? change24h;
    final now = double.tryParse(priceText);
    final open = double.tryParse(data['open_24h']?.toString() ?? '');
    if (now != null && open != null && open > 0) {
      change24h = Decimal.parse((((now - open) / open) * 100).toStringAsFixed(2));
    }

    // Buffer and flush in batches so the UI rebuilds at most ~2x per second,
    // no matter how many matches BTC/ETH print.
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

  void _onServerError(Map<String, dynamic> data) {
    _log('SERVER ERROR: ${jsonEncode(data)}');

    // Assumes the error text names the offending product ("XYZ-USD ...").
    // If the log line above shows a different shape, adjust this regex.
    final text = '${data['message']} ${data['reason']}';
    final match = RegExp(r'\b([A-Z0-9]+)-USD\b').firstMatch(text);
    if (match == null) return;

    final bad = match.group(1)!;
    if (_rejected.add(bad)) {
      _log('dropping unsupported product $bad-USD and resubscribing');
      final channel = _channel;
      if (channel != null) _sendSubscribe(channel);
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;
    _generation++; // ignore any further callbacks from the dead socket
    _teardown();
    _reconnectTimer?.cancel();

    _reconnectAttempts++;
    // 2s, 4s, 8s, 16s, then 30s.
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
