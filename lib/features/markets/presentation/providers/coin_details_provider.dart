import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:wallet/features/markets/domain/entities/news_article_entity.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

part 'coin_details_provider.g.dart';

@riverpod
Future<List<Candle>> coinCandles(
  Ref ref, 
  String symbol, 
  String granularity,
) async {
  final repository = ref.watch(marketRepositoryProvider);
  return repository.getHistoricalCandles(symbol, granularity);
}

@riverpod
Future<List<NewsArticleEntity>> coinNews(
  Ref ref, 
  String symbol,
) async {
  final repository = ref.watch(marketRepositoryProvider);
  return repository.getCoinNews(symbol);
}
