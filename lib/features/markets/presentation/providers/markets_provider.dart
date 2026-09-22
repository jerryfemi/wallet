import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/data/sources/coingecko_api_service.dart';
import 'package:wallet/features/markets/data/repositories/market_repository.dart';
import 'package:wallet/core/network/dio_client.dart';
import 'package:wallet/features/markets/data/sources/coinbase_websocket_datasource.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

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
CoinbaseWebSocketDataSource coinbaseWebSocketDataSource(Ref ref) {
  final dataSource = CoinbaseWebSocketDataSource();
  ref.onDispose(() {
    dataSource.dispose();
  });
  return dataSource;
}

@riverpod
MarketRepository marketRepository(Ref ref) {
  final apiService = ref.watch(coinGeckoApiServiceProvider);
  final wsDataSource = ref.watch(coinbaseWebSocketDataSourceProvider);
  return MarketRepository(apiService, wsDataSource);
}

@Riverpod(keepAlive: true)
class LivePrices extends _$LivePrices {
  @override
  Map<String, TickerUpdateEntity> build() {
    final repository = ref.watch(marketRepositoryProvider);

    final subscription = repository.getLiveTickerStream().listen((updates) {
      final next = Map<String, TickerUpdateEntity>.from(state);
      for (final update in updates) {
        next[update.symbol] = TickerUpdateEntity(
          symbol: update.symbol,
          price: update.price,
          // Fall back to the last known % if a tick didn't carry one.
          priceChangePercentage24h:
              update.priceChangePercentage24h ??
              next[update.symbol]?.priceChangePercentage24h,
        );
      }
      state = next;
    });
    ref.onDispose(subscription.cancel);

    // Bug 4 fix: when the user brings the app back to the foreground the
    // WebSocket may be dead (zombie TCP / OS killed it during sleep). Force a
    // fresh connect so ticks resume immediately instead of waiting for the
    // 20-second silence watchdog to kick in.
    final lifecycle = AppLifecycleListener(
      onResume: repository.reconnectLiveTickers,
    );
    ref.onDispose(lifecycle.dispose);

    // listen, NOT watch: a markets refresh (AsyncLoading -> AsyncData) must not
    // rebuild this notifier, otherwise it resets the price map to {} and
    // re-subscribes every time.
    ref.listen<AsyncValue<List<CoinEntity>>>(marketsProvider, (_, next) {
      final coins = next.value;
      if (coins == null) return;
      repository.subscribeToLiveTickers(coins.map((c) => c.symbol).toList());
    }, fireImmediately: true);

    return const <String, TickerUpdateEntity>{};
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
