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
