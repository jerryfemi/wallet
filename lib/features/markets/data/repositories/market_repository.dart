import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/data/models/coin_model.dart';
import 'package:wallet/features/markets/data/sources/coingecko_api_service.dart';
import 'package:wallet/features/markets/data/sources/coinbase_websocket_datasource.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

class MarketRepository {
  final CoinGeckoApiService _apiService;
  final CoinbaseWebSocketDataSource _webSocketDataSource;

  MarketRepository(this._apiService, this._webSocketDataSource);

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

  /// Exposes a stream of [TickerUpdateEntity] lists representing live price ticks.
  Stream<List<TickerUpdateEntity>> getLiveTickerStream() {
    return _webSocketDataSource.liveTickerStream;
  }
  
  void subscribeToLiveTickers(List<String> symbols) {
    _webSocketDataSource.subscribeToSymbols(symbols);
  }
}
