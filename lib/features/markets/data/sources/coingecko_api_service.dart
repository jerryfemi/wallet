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
      throw Exception('Failed to fetch market data: $e');
    }
  }
}
