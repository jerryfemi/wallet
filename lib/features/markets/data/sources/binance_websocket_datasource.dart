import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wallet/features/markets/data/models/binance_ticker_model.dart';

class BinanceWebSocketDataSource {
  static const String _url = 'wss://stream.binance.com:9443/ws/!ticker@arr';
  WebSocketChannel? _channel;

  /// Returns a stream of lists containing the parsed Binance ticker models
  Stream<List<BinanceTickerModel>> get liveTickerStream {
    // Connect if not already connected
    _channel ??= WebSocketChannel.connect(Uri.parse(_url));

    return _channel!.stream.map((event) {
      final List<dynamic> data = jsonDecode(event.toString());
      return data.map((json) => BinanceTickerModel.fromJson(json as Map<String, dynamic>)).toList();
    });
  }

  void dispose() {
    _channel?.sink.close();
    _channel = null;
  }
}
