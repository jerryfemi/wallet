import 'package:dio/dio.dart';
import 'package:wallet/features/markets/domain/entities/news_article_entity.dart';

class CryptoCompareApiService {
  // ignore: unused_field
  final Dio _dio;

  CryptoCompareApiService(this._dio);

  Future<List<NewsArticleEntity>> getCoinNews(String symbol) async {
    // CryptoCompare (CoinDesk Data) now strictly requires an API key for the v2 news endpoint.
    // Returning high-quality mock data for now so we can build out the beautiful UI.
    // Once you get a free API key from min-api.cryptocompare.com, we can plug it in here!
    
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency

    return [
      NewsArticleEntity(
        title: 'US spot ${symbol.toUpperCase()} ETFs received significant inflows recently, turning year-to-date performance positive.',
        source: 'Market Insights',
        url: 'https://cointelegraph.com',
        imageUrl: 'https://images.cryptocompare.com/news/default/coindesk.png',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 44)),
        sentiment: 'Bullish',
      ),
      NewsArticleEntity(
        title: 'Strategy Adds 950 ${symbol.toUpperCase()} to 846,000 Holdings as Corporate Purchases Resume',
        source: 'CoinDesk',
        url: 'https://www.coindesk.com',
        imageUrl: 'https://images.cryptocompare.com/news/default/coindesk.png',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        sentiment: 'Bullish',
      ),
      NewsArticleEntity(
        title: 'Senate fails to advance CLARITY Act in 49-50 vote, falling short as crypto markets react.',
        source: 'Decrypt',
        url: 'https://decrypt.co',
        imageUrl: 'https://images.cryptocompare.com/news/default/decrypt.png',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        sentiment: 'Bearish',
      ),
    ];
  }
}
