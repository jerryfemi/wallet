// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Currency)
final currencyProvider = CurrencyProvider._();

final class CurrencyProvider extends $NotifierProvider<Currency, AppCurrency> {
  CurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyHash();

  @$internal
  @override
  Currency create() => Currency();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppCurrency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppCurrency>(value),
    );
  }
}

String _$currencyHash() => r'51990a92fed82b06ba5033d31571e2fc5c853bac';

abstract class _$Currency extends $Notifier<AppCurrency> {
  AppCurrency build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppCurrency, AppCurrency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppCurrency, AppCurrency>,
              AppCurrency,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
