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

String _$walletRepositoryHash() => r'1d1dc9a09bbbaf784fef71f4f6df625c81b9e159';

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

String _$walletStreamHash() => r'93185b0a5f29e5b8e45981addefdc05f5c4d0c6a';

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
    r'f39470d077148f3e43ebd4335a728130df07ac03';
