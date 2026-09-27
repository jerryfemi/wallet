import 'package:dio/dio.dart';
import 'package:candlesticks/candlesticks.dart';

class CoinbaseApiService {
  final Dio _dio;

  CoinbaseApiService(this._dio);

  Future<List<Candle>> getHistoricalCandles(String symbol, String granularity) async {
    final formattedSymbol = '${symbol.toUpperCase()}-USD';
    
    try {
      final response = await _dio.get(
        'https://api.exchange.coinbase.com/products/$formattedSymbol/candles',
        queryParameters: {
          'granularity': granularity,
        },
      );

      final List<dynamic> data = response.data;
      
      // Coinbase format: [ time, low, high, open, close, volume ]
      return data.map((json) {
        return Candle(
          date: DateTime.fromMillisecondsSinceEpoch((json[0] as num).toInt() * 1000),
          low: (json[1] as num).toDouble(),
          high: (json[2] as num).toDouble(),
          open: (json[3] as num).toDouble(),
          close: (json[4] as num).toDouble(),
          volume: (json[5] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch historical candles: $e');
    }
  }
}
