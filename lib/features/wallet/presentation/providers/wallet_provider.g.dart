// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walletRepository)
final walletRepositoryProvider = WalletRepositoryProvider._();

final class WalletRepositoryProvider
    extends
        $FunctionalProvider<
          WalletRepository,
          WalletRepository,
          WalletRepository
        >
    with $Provider<WalletRepository> {
  WalletRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletRepositoryHash();

  @$internal
  @override
  $ProviderElement<WalletRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WalletRepository create(Ref ref) {
    return walletRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletRepository>(value),
    );
  }
}

String _$walletRepositoryHash() => r'9ea1211027cc05f4b51306b97b3b34e532e7fef5';

@ProviderFor(walletStream)
final walletStreamProvider = WalletStreamProvider._();

final class WalletStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<WalletEntity?>,
          WalletEntity?,
          Stream<WalletEntity?>
        >
    with $FutureModifier<WalletEntity?>, $StreamProvider<WalletEntity?> {
  WalletStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletStreamHash();

  @$internal
  @override
  $StreamProviderElement<WalletEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WalletEntity?> create(Ref ref) {
    return walletStream(ref);
  }
}

String _$walletStreamHash() => r'e5e6c2cef499da6ad9de96f4b36e1f499453aa21';

@ProviderFor(transactionsStream)
final transactionsStreamProvider = TransactionsStreamProvider._();

final class TransactionsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionEntity>>,
          List<TransactionEntity>,
          Stream<List<TransactionEntity>>
        >
    with
        $FutureModifier<List<TransactionEntity>>,
        $StreamProvider<List<TransactionEntity>> {
  TransactionsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionEntity>> create(Ref ref) {
    return transactionsStream(ref);
  }
}

String _$transactionsStreamHash() =>
    r'd085439f05094a7bdb6fc86c9a34f9432a374f6a';

@ProviderFor(portfolioAssets)
final portfolioAssetsProvider = PortfolioAssetsProvider._();

final class PortfolioAssetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PortfolioAsset>>,
          List<PortfolioAsset>,
          FutureOr<List<PortfolioAsset>>
        >
    with
        $FutureModifier<List<PortfolioAsset>>,
        $FutureProvider<List<PortfolioAsset>> {
  PortfolioAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioAssetsHash();

  @$internal
  @override
  $FutureProviderElement<List<PortfolioAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PortfolioAsset>> create(Ref ref) {
    return portfolioAssets(ref);
  }
}

String _$portfolioAssetsHash() => r'feca3ac235f12071224bd0126002737b8b09a0b0';

@ProviderFor(portfolioTotalValue)
final portfolioTotalValueProvider = PortfolioTotalValueProvider._();

final class PortfolioTotalValueProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  PortfolioTotalValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioTotalValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioTotalValueHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return portfolioTotalValue(ref);
  }
}

String _$portfolioTotalValueHash() =>
    r'a63cfd5304a8e49bd899c9c3db372e0f05ef87d8';

@ProviderFor(portfolioTotalChange24h)
final portfolioTotalChange24hProvider = PortfolioTotalChange24hProvider._();

final class PortfolioTotalChange24hProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  PortfolioTotalChange24hProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioTotalChange24hProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioTotalChange24hHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return portfolioTotalChange24h(ref);
  }
}

String _$portfolioTotalChange24hHash() =>
    r'efcaa746143b03ed7671d8caf86038391a2bfa25';
