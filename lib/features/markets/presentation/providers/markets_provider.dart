import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/data/sources/coingecko_api_service.dart';
import 'package:wallet/features/markets/data/repositories/market_repository.dart';
import 'package:wallet/core/network/dio_client.dart';
import 'package:wallet/features/markets/data/sources/binance_websocket_datasource.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

import 'dart:async';

part 'markets_provider.g.dart';

@riverpod
DioClient dioClient(Ref ref) {
  return DioClient();
}

@riverpod
CoinGeckoApiService coinGeckoApiService(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CoinGeckoApiService(dioClient);
}

@riverpod
BinanceWebSocketDataSource binanceWebSocketDataSource(Ref ref) {
  final dataSource = BinanceWebSocketDataSource();
  ref.onDispose(() {
    dataSource.dispose();
  });
  return dataSource;
}

@riverpod
MarketRepository marketRepository(Ref ref) {
  final apiService = ref.watch(coinGeckoApiServiceProvider);
  final wsDataSource = ref.watch(binanceWebSocketDataSourceProvider);
  return MarketRepository(apiService, wsDataSource);
}

@riverpod
class LivePrices extends _$LivePrices {
  StreamSubscription? _subscription;

  @override
  Map<String, TickerUpdateEntity> build() {
    final repository = ref.watch(marketRepositoryProvider);
    
    _subscription = repository.getLiveTickerStream().listen((updates) {
      final newMap = Map<String, TickerUpdateEntity>.from(state);
      for (final update in updates) {
        newMap[update.symbol] = update;
      }
      state = newMap;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return {};
  }
}

@riverpod
class Markets extends _$Markets {
  @override
  Future<List<CoinEntity>> build() async {
    return _fetchMarkets();
  }

  Future<List<CoinEntity>> _fetchMarkets() async {
    final repository = ref.watch(marketRepositoryProvider);
    return await repository.getTopCoins();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMarkets());
  }
}

enum MarketFilter { all, gainers, losers, volume }

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) => state = query;
}

@riverpod
class ActiveMarketFilter extends _$ActiveMarketFilter {
  @override
  MarketFilter build() => MarketFilter.all;

  void setFilter(MarketFilter filter) => state = filter;
}

@riverpod
Future<List<CoinEntity>> filteredMarkets(Ref ref) async {
  final markets = await ref.watch(marketsProvider.future);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filter = ref.watch(activeMarketFilterProvider);

  var filtered = markets;

  if (query.isNotEmpty) {
    filtered = filtered.where((coin) {
      return coin.name.toLowerCase().contains(query) ||
             coin.symbol.toLowerCase().contains(query);
    }).toList();
  } else {
    // creating a shallow copy to safely sort without mutating the original list
    filtered = List.from(markets);
  }

  switch (filter) {
    case MarketFilter.gainers:
      filtered.sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
      break;
    case MarketFilter.losers:
      filtered.sort((a, b) => a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
      break;
    case MarketFilter.volume:
      filtered.sort((a, b) => b.totalVolume.compareTo(a.totalVolume));
      break;
    case MarketFilter.all:
      // By default it comes sorted by market cap from the API
      break;
  }

  return filtered;
}

@riverpod
Future<List<CoinEntity>> topMovers(Ref ref) async {
  final markets = await ref.watch(marketsProvider.future);
  
  // Sort by absolute price change (highest volatility)
  var sorted = List<CoinEntity>.from(markets);
  sorted.sort((a, b) => b.priceChangePercentage24h.abs().compareTo(a.priceChangePercentage24h.abs()));
  
  return sorted.take(5).toList();
}
