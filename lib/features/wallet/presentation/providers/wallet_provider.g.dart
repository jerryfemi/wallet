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

String _$portfolioAssetsHash() => r'701dce2d56e3c99a4bd62f0e550fad10145645d5';

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
    r'6d75d77cefbd37ebf53555e2ff41be8493a65435';

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

@ProviderFor(simulateDeposit)
final simulateDepositProvider = SimulateDepositFamily._();

final class SimulateDepositProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  SimulateDepositProvider._({
    required SimulateDepositFamily super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'simulateDepositProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$simulateDepositHash();

  @override
  String toString() {
    return r'simulateDepositProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as double;
    return simulateDeposit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SimulateDepositProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simulateDepositHash() => r'293895158092173098c3d7349d338d5e79786883';

final class SimulateDepositFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, double> {
  SimulateDepositFamily._()
    : super(
        retry: null,
        name: r'simulateDepositProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SimulateDepositProvider call(double amount) =>
      SimulateDepositProvider._(argument: amount, from: this);

  @override
  String toString() => r'simulateDepositProvider';
}
