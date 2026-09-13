import '../../domain/entities/coin_entity.dart';
import '../models/coin_model.dart';
import '../sources/coingecko_api_service.dart';

class MarketRepository {
  final CoinGeckoApiService _apiService;

  MarketRepository(this._apiService);

  Future<List<CoinEntity>> getTopCoins() async {
    final List<CoinModel> models = await _apiService.getTopCoins();
    
    return models.map((model) {
      return CoinEntity(
        id: model.id,
        symbol: model.symbol.toUpperCase(),
        name: model.name,
        imageUrl: model.image,
        currentPrice: model.currentPrice,
        marketCap: model.marketCap,
        marketCapRank: model.marketCapRank,
        totalVolume: model.totalVolume,
        priceChangePercentage24h: model.priceChangePercentage24h,
        sparkline: model.sparklineIn7d?.price ?? [],
      );
    }).toList();
  }
}
