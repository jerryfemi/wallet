// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveTransactionFilter)
final activeTransactionFilterProvider = ActiveTransactionFilterProvider._();

final class ActiveTransactionFilterProvider
    extends $NotifierProvider<ActiveTransactionFilter, TransactionFilter> {
  ActiveTransactionFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTransactionFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTransactionFilterHash();

  @$internal
  @override
  ActiveTransactionFilter create() => ActiveTransactionFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFilter>(value),
    );
  }
}

String _$activeTransactionFilterHash() =>
    r'120c6d40ce1161a89f029cf20e3eb0a032268327';

abstract class _$ActiveTransactionFilter extends $Notifier<TransactionFilter> {
  TransactionFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionFilter, TransactionFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFilter, TransactionFilter>,
              TransactionFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
