import 'package:dio/dio.dart';
import '../models/coin_model.dart';
import '../../../../core/network/dio_client.dart';

class CoinGeckoApiService {
  final DioClient _dioClient;

  CoinGeckoApiService(this._dioClient);

  /// Fetch top coins by market cap
  Future<List<CoinModel>> getTopCoins({
    String vsCurrency = 'usd',
    int perPage = 50,
    int page = 1,
    bool sparkline = true,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': vsCurrency,
          'order': 'market_cap_desc',
          'per_page': perPage,
          'page': page,
          'sparkline': sparkline,
          'price_change_percentage': '24h',
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => CoinModel.fromJson(json)).toList();
    } catch (e) {
      if (e.toString().contains('429')) {
        // Fallback to mock data when CoinGecko free tier limits are hit during dev
        return _getMockData();
      }
      throw Exception('Failed to fetch market data: $e');
    }
  }

  List<CoinModel> _getMockData() {
    final mockJson = [
      {
        "id": "bitcoin",
        "symbol": "btc",
        "name": "Bitcoin",
        "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        "current_price": 64230.00,
        "market_cap": 1200000000000.0,
        "market_cap_rank": 1,
        "total_volume": 35000000000.0,
        "price_change_percentage_24h": 2.5,
        "sparkline_in_7d": {
          "price": [60000.0, 61000.0, 63000.0, 62500.0, 64230.0]
        }
      },
      {
        "id": "ethereum",
        "symbol": "eth",
        "name": "Ethereum",
        "image": "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
        "current_price": 3450.00,
        "market_cap": 400000000000.0,
        "market_cap_rank": 2,
        "total_volume": 15000000000.0,
        "price_change_percentage_24h": -1.2,
        "sparkline_in_7d": {
          "price": [3600.0, 3500.0, 3400.0, 3480.0, 3450.0]
        }
      },
      {
        "id": "solana",
        "symbol": "sol",
        "name": "Solana",
        "image": "https://assets.coingecko.com/coins/images/4128/large/solana.png",
        "current_price": 145.20,
        "market_cap": 65000000000.0,
        "market_cap_rank": 5,
        "total_volume": 3500000000.0,
        "price_change_percentage_24h": 5.8,
        "sparkline_in_7d": {
          "price": [130.0, 135.0, 140.0, 142.0, 145.20]
        }
      }
    ];
    return mockJson.map((json) => CoinModel.fromJson(json)).toList();
  }
}
