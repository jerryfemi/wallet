import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

class CoinbaseWebSocketDataSource {
  static const String _url = 'wss://ws-feed.exchange.coinbase.com';
  WebSocketChannel? _channel;
  Stream<List<TickerUpdateEntity>>? _broadcastStream;
  bool _isConnected = false;

  void subscribeToSymbols(List<String> symbols) {
    if (symbols.isEmpty) return;

    // Coinbase uses pairs like "BTC-USD"
    final productIds = symbols.map((s) => '$s-USD').toList();

    final subscribeMsg = {
      "type": "subscribe",
      "product_ids": productIds,
      "channels": ["ticker"],
    };

    _channel ??= WebSocketChannel.connect(Uri.parse(_url));
    _channel!.sink.add(jsonEncode(subscribeMsg));
  }

  Stream<List<TickerUpdateEntity>> get liveTickerStream {
    _channel ??= WebSocketChannel.connect(Uri.parse(_url));

    _broadcastStream ??= _channel!.stream
        .map((event) {
          try {
            final Map<String, dynamic> data = jsonDecode(event.toString());

            if (data['type'] == 'ticker' && data.containsKey('price')) {
              final productId = data['product_id'] as String; // e.g., "BTC-USD"
              final symbol = productId.split('-').first.toLowerCase(); // "btc"

              final priceStr = data['price'];

              // Coinbase ticker channel doesn't easily provide 24h% directly in the live tick,
              // so we'll leave it null and let our provider merge it with CoinGecko's % just like we did for CoinCap.

              return [
                TickerUpdateEntity(
                  symbol: symbol,
                  price: Decimal.parse(priceStr.toString()),
                  priceChangePercentage24h: null,
                ),
              ];
            }
            return <TickerUpdateEntity>[];
          } catch (e) {
            return <TickerUpdateEntity>[];
          }
        })
        .handleError((error) {
          print('Coinbase WS Error: $error');
        })
        .asBroadcastStream();

    return _broadcastStream!;
  }

  void dispose() {
    _channel?.sink.close();
    _channel = null;
    _broadcastStream = null;
    _isConnected = false;
  }
}
