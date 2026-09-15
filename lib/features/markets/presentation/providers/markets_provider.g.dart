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

String _$marketRepositoryHash() => r'6d5b0ae6f61ad1b139f581f31c466d72f64efcc0';

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

String _$marketsHash() => r'f33e4668345914825edd1902bbb372f59cc56ec3';

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
