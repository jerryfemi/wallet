import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wallet/features/markets/data/models/binance_ticker_model.dart';

class BinanceWebSocketDataSource {
  // fstream is the Binance Futures endpoint. It uses the exact same format but is hosted on a different domain
  // that is rarely blocked by ISPs compared to the main stream.binance.com domain.
  static const String _url = 'wss://fstream.binance.com/ws/!ticker@arr';
  WebSocketChannel? _channel;
  Stream<List<BinanceTickerModel>>? _broadcastStream;

  /// Returns a stream of lists containing the parsed Binance ticker models
  Stream<List<BinanceTickerModel>> get liveTickerStream {
    if (_channel == null) {
      print('Binance WS: Connecting to $_url...');
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _broadcastStream = _channel!.stream
          .map((event) {
            // print('Binance WS: Received payload of length ${event.toString().length}');
            try {
              final List<dynamic> data = jsonDecode(event.toString());
              return data
                  .map(
                    (json) => BinanceTickerModel.fromJson(
                      json as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            } catch (e) {
              print('Binance WS: Error parsing JSON: $e');
              return <BinanceTickerModel>[];
            }
          })
          .handleError((error) {
            print('Binance WS: Stream Error: $error');
          })
          .asBroadcastStream();
    }
    return _broadcastStream!;
  }

  void dispose() {
    _channel?.sink.close();
    _channel = null;
    _broadcastStream = null;
  }
}
