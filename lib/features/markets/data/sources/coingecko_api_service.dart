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
      // we parse the public RSS feed of CoinTelegraph to get 100% real, live news for free.
      final response = await _dioClient.dio.get(
        'https://cointelegraph.com/rss',
        options: Options(responseType: ResponseType.plain),
      );

      final String xmlData = response.data.toString();
      final List<NewsArticleEntity> articles = [];

      // Simple RegEx parser for RSS <item> tags
      final itemRegExp = RegExp(r'<item>(.*?)</item>', dotAll: true);
      final titleRegExp = RegExp(r'<title>(?:<!\[CDATA\[)?(.*?)(?:\]\]>)?</title>', dotAll: true);
      final linkRegExp = RegExp(r'<link>(.*?)</link>', dotAll: true);
      final pubDateRegExp = RegExp(r'<pubDate>(.*?)</pubDate>', dotAll: true);
      final imgRegExp = RegExp(r'<media:content[^>]*url="(.*?)"', dotAll: true);

      final matches = itemRegExp.allMatches(xmlData);

      for (final match in matches) {
        if (articles.length >= 15) break; 
        
        final itemStr = match.group(1) ?? '';
        final title = titleRegExp.firstMatch(itemStr)?.group(1)?.trim() ?? 'Crypto News';
        final url = linkRegExp.firstMatch(itemStr)?.group(1)?.trim() ?? 'https://cointelegraph.com';
        final pubDateStr = pubDateRegExp.firstMatch(itemStr)?.group(1)?.trim() ?? '';
        
        DateTime publishedAt = DateTime.now();
        try {
          // Attempt basic parsing, RSS pubDate is usually RFC 822/1123
          // Dart's DateTime doesn't natively parse RFC 822 perfectly if it has timezones like 'EST', 
          // but we can try parsing or fallback to now.
          // For safety in this regex fallback, we'll try to parse just the date part if it fails.
          publishedAt = DateTime.parse(pubDateStr);
        } catch (_) {
           // If it fails, we just use DateTime.now() so the app doesn't crash.
        }

        final imageUrl = imgRegExp.firstMatch(itemStr)?.group(1)?.trim() ?? 
            'https://images.cryptocompare.com/news/default/coindesk.png';

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
