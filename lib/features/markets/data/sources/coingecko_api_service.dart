import 'package:wallet/features/markets/data/models/coin_model.dart';
import 'package:wallet/core/network/dio_client.dart';
import 'package:wallet/features/markets/domain/entities/news_article_entity.dart';
import 'package:dio/dio.dart';

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

  /// Fetch detailed token info for the "About Coin" screen.
  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    try {
      final response = await _dioClient.dio.get(
        '/coins/$coinId',
        queryParameters: {
          'localization': 'false',
          'tickers': 'false',
          'market_data': 'true',
          'community_data': 'true',
          'developer_data': 'false',
          'sparkline': 'false',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch CoinGecko details for $coinId: $e');
    }
  }

  /// Fetch related news (Fallback to CoinGecko-styled mock if Pro API isn't available)
  Future<List<NewsArticleEntity>> getCoinNews(String symbol) async {
    try {
      // Since most crypto news APIs require a paid API key now (CoinGecko, CryptoCompare),
      // we use rss2json to parse the public RSS feed of CoinTelegraph to get 100% real, live news for free
      // and bypass CORS/Cloudflare restrictions on the direct RSS XML endpoint.
      final response = await _dioClient.dio.get(
        'https://api.rss2json.com/v1/api.json?rss_url=https://cointelegraph.com/rss',
      );

      final List<dynamic> items = response.data['items'] ?? [];
      final List<NewsArticleEntity> articles = [];

      for (final item in items) {
        if (articles.length >= 15) break; 
        
        final title = item['title'] ?? 'Crypto News';
        final url = item['link'] ?? 'https://cointelegraph.com';
        final pubDateStr = item['pubDate'] ?? '';
        
        DateTime publishedAt = DateTime.now();
        try {
          publishedAt = DateTime.parse(pubDateStr);
        } catch (_) {
           // If it fails, we just use DateTime.now()
        }

        String imageUrl = 'https://images.cryptocompare.com/news/default/coindesk.png';
        if (item['enclosure'] != null && item['enclosure']['link'] != null) {
          imageUrl = item['enclosure']['link'];
        } else if (item['thumbnail'] != null && item['thumbnail'].toString().isNotEmpty) {
          imageUrl = item['thumbnail'];
        }

        articles.add(NewsArticleEntity(
          title: title,
          source: 'CoinTelegraph',
          url: url,
          imageUrl: imageUrl,
          publishedAt: publishedAt,
          sentiment: 'Neutral',
        ));
      }

      return articles.isEmpty ? [] : articles;
    } catch (e) {
      throw Exception('Failed to fetch real news from RSS: $e');
    }
  }
}
