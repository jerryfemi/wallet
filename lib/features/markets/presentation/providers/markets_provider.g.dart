// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

final class DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$dioClientHash() => r'e6a9dcce6804aa95cb3ea31bbb6d28ca56890385';

@ProviderFor(coinGeckoApiService)
final coinGeckoApiServiceProvider = CoinGeckoApiServiceProvider._();

final class CoinGeckoApiServiceProvider
    extends
        $FunctionalProvider<
          CoinGeckoApiService,
          CoinGeckoApiService,
          CoinGeckoApiService
        >
    with $Provider<CoinGeckoApiService> {
  CoinGeckoApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coinGeckoApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coinGeckoApiServiceHash();

  @$internal
  @override
  $ProviderElement<CoinGeckoApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoinGeckoApiService create(Ref ref) {
    return coinGeckoApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoinGeckoApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoinGeckoApiService>(value),
    );
  }
}

String _$coinGeckoApiServiceHash() =>
    r'8526d98bf0c2a78dadf0c27ab962a40a0e8fa556';

@ProviderFor(coinbaseWebSocketDataSource)
final coinbaseWebSocketDataSourceProvider =
    CoinbaseWebSocketDataSourceProvider._();

final class CoinbaseWebSocketDataSourceProvider
    extends
        $FunctionalProvider<
          CoinbaseWebSocketDataSource,
          CoinbaseWebSocketDataSource,
          CoinbaseWebSocketDataSource
        >
    with $Provider<CoinbaseWebSocketDataSource> {
  CoinbaseWebSocketDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coinbaseWebSocketDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coinbaseWebSocketDataSourceHash();

  @$internal
  @override
  $ProviderElement<CoinbaseWebSocketDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoinbaseWebSocketDataSource create(Ref ref) {
    return coinbaseWebSocketDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoinbaseWebSocketDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoinbaseWebSocketDataSource>(value),
    );
  }
}

String _$coinbaseWebSocketDataSourceHash() =>
    r'30d7c38e8d3faa325fe56e17aa7d7e159b8fe3fb';

@ProviderFor(marketLocalDataSource)
final marketLocalDataSourceProvider = MarketLocalDataSourceProvider._();

final class MarketLocalDataSourceProvider
    extends
        $FunctionalProvider<
          MarketLocalDataSource,
          MarketLocalDataSource,
          MarketLocalDataSource
        >
    with $Provider<MarketLocalDataSource> {
  MarketLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<MarketLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarketLocalDataSource create(Ref ref) {
    return marketLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketLocalDataSource>(value),
    );
  }
}

String _$marketLocalDataSourceHash() =>
    r'3d7961b40ed0d0bbd18b09eec76da3e22e31ff7d';

@ProviderFor(marketRepository)
final marketRepositoryProvider = MarketRepositoryProvider._();

final class MarketRepositoryProvider
    extends
        $FunctionalProvider<
          MarketRepository,
          MarketRepository,
          MarketRepository
        >
    with $Provider<MarketRepository> {
  MarketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketRepositoryHash();

  @$internal
  @override
  $ProviderElement<MarketRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarketRepository create(Ref ref) {
    return marketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketRepository>(value),
    );
  }
}

String _$marketRepositoryHash() => r'7380092e2d6a12c60aa7cb39fb2a047f280a3cee';

@ProviderFor(LivePrices)
final livePricesProvider = LivePricesProvider._();

final class LivePricesProvider
    extends $NotifierProvider<LivePrices, Map<String, TickerUpdateEntity>> {
  LivePricesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'livePricesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$livePricesHash();

  @$internal
  @override
  LivePrices create() => LivePrices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, TickerUpdateEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, TickerUpdateEntity>>(
        value,
      ),
    );
  }
}

String _$livePricesHash() => r'77d64466acef2226037763484a82df80223fb8a2';

abstract class _$LivePrices extends $Notifier<Map<String, TickerUpdateEntity>> {
  Map<String, TickerUpdateEntity> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, TickerUpdateEntity>,
              Map<String, TickerUpdateEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, TickerUpdateEntity>,
                Map<String, TickerUpdateEntity>
              >,
              Map<String, TickerUpdateEntity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Markets)
final marketsProvider = MarketsProvider._();

final class MarketsProvider
    extends $AsyncNotifierProvider<Markets, List<CoinEntity>> {
  MarketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketsHash();

  @$internal
  @override
  Markets create() => Markets();
}

String _$marketsHash() => r'da328ec76b4a914d4467740fa308cf1274610e43';

abstract class _$Markets extends $AsyncNotifier<List<CoinEntity>> {
  FutureOr<List<CoinEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CoinEntity>>, List<CoinEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CoinEntity>>, List<CoinEntity>>,
              AsyncValue<List<CoinEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'c20c8b67cdf9a8c8820d422de83c580e88655dcd';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveMarketFilter)
final activeMarketFilterProvider = ActiveMarketFilterProvider._();

final class ActiveMarketFilterProvider
    extends $NotifierProvider<ActiveMarketFilter, MarketFilter> {
  ActiveMarketFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMarketFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMarketFilterHash();

  @$internal
  @override
  ActiveMarketFilter create() => ActiveMarketFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketFilter>(value),
    );
  }
}

String _$activeMarketFilterHash() =>
    r'0df9b98b1159583a49d72fd287409e29420c9394';

abstract class _$ActiveMarketFilter extends $Notifier<MarketFilter> {
  MarketFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MarketFilter, MarketFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MarketFilter, MarketFilter>,
              MarketFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredMarkets)
final filteredMarketsProvider = FilteredMarketsProvider._();

final class FilteredMarketsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoinEntity>>,
          List<CoinEntity>,
          FutureOr<List<CoinEntity>>
        >
    with $FutureModifier<List<CoinEntity>>, $FutureProvider<List<CoinEntity>> {
  FilteredMarketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMarketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMarketsHash();

  @$internal
  @override
  $FutureProviderElement<List<CoinEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoinEntity>> create(Ref ref) {
    return filteredMarkets(ref);
  }
}

String _$filteredMarketsHash() => r'954ff632a0b403c6356cb4fc093f4f5588b82a45';

@ProviderFor(topMovers)
final topMoversProvider = TopMoversProvider._();

final class TopMoversProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoinEntity>>,
          List<CoinEntity>,
          FutureOr<List<CoinEntity>>
        >
    with $FutureModifier<List<CoinEntity>>, $FutureProvider<List<CoinEntity>> {
  TopMoversProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topMoversProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topMoversHash();

  @$internal
  @override
  $FutureProviderElement<List<CoinEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoinEntity>> create(Ref ref) {
    return topMovers(ref);
  }
}

String _$topMoversHash() => r'374fab5adac02bb05ab790675758d8a932c80db7';
