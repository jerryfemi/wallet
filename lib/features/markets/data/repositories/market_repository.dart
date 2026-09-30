import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/data/models/coin_model.dart';
import 'package:wallet/features/markets/data/sources/coingecko_api_service.dart';
import 'package:wallet/features/markets/data/sources/coinbase_websocket_datasource.dart';
import 'package:wallet/features/markets/data/sources/market_local_datasource.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';
import 'package:wallet/features/markets/data/sources/coinbase_api_service.dart';
import 'package:wallet/features/markets/data/sources/cryptocompare_api_service.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:wallet/features/markets/domain/entities/news_article_entity.dart';

class MarketRepository {
  final CoinGeckoApiService _apiService;
  final CoinbaseWebSocketDataSource _webSocketDataSource;
  final MarketLocalDataSource _localDataSource;

  final CoinbaseApiService _coinbaseApiService;
  final CryptoCompareApiService _cryptoCompareApiService;

  MarketRepository(
    this._apiService, 
    this._webSocketDataSource, 
    this._localDataSource,
    this._coinbaseApiService,
    this._cryptoCompareApiService,
  );

  /// Fetches top coins from CoinGecko and persists them to the local cache.
  Future<List<CoinEntity>> getTopCoins() async {
    final List<CoinModel> models = await _apiService.getTopCoins();

    // Write-through: persist to disk so subsequent launches are instant.
    await _localDataSource.saveCoins(models);

    return models.map(_toEntity).toList();
  }

  /// Returns the previously cached coin list from disk, or `null` if no cache
  /// exists. Used to render the UI instantly before a network call completes.
  Future<List<CoinEntity>?> getCachedCoins() async {
    final models = await _localDataSource.getCachedCoins();
    if (models == null) return null;
    return models.map(_toEntity).toList();
  }

  CoinEntity _toEntity(CoinModel model) {
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
  }

  /// Exposes a stream of [TickerUpdateEntity] lists representing live price ticks.
  Stream<List<TickerUpdateEntity>> getLiveTickerStream() {
    return _webSocketDataSource.liveTickerStream;
  }
  
  void subscribeToLiveTickers(List<String> symbols) {
    _webSocketDataSource.subscribeToSymbols(symbols);
  }
  
  void reconnectLiveTickers() {
    _webSocketDataSource.reconnect();
  }

  Future<List<Candle>> getHistoricalCandles(String symbol, String granularity) async {
    // Try to get the fallback price from the locally cached CoinGecko data
    double? fallbackPrice;
    try {
      final cachedCoins = await getCachedCoins();
      if (cachedCoins != null) {
        final coin = cachedCoins.firstWhere(
          (c) => c.symbol.toUpperCase() == symbol.toUpperCase(),
          orElse: () => cachedCoins.first, // Fallback to something if not found
        );
        fallbackPrice = coin.currentPrice.toDouble();
      }
    } catch (_) {
      // Ignore cache errors
    }

    return await _coinbaseApiService.getHistoricalCandles(symbol, granularity, fallbackPrice: fallbackPrice);
  }

  Future<List<NewsArticleEntity>> getCoinNews(String symbol) async {
    return await _apiService.getCoinNews(symbol);
  }

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    return await _apiService.getCoinDetails(coinId);
  }
}

