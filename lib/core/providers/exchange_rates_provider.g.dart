// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fxRatesService)
final fxRatesServiceProvider = FxRatesServiceProvider._();

final class FxRatesServiceProvider
    extends $FunctionalProvider<FxRatesService, FxRatesService, FxRatesService>
    with $Provider<FxRatesService> {
  FxRatesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fxRatesServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fxRatesServiceHash();

  @$internal
  @override
  $ProviderElement<FxRatesService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FxRatesService create(Ref ref) {
    return fxRatesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FxRatesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FxRatesService>(value),
    );
  }
}

String _$fxRatesServiceHash() => r'1f254f0884ccf4c88f4a3f3c9bd113252ccdca40';

@ProviderFor(ExchangeRates)
final exchangeRatesProvider = ExchangeRatesProvider._();

final class ExchangeRatesProvider
    extends $AsyncNotifierProvider<ExchangeRates, Map<String, double>> {
  ExchangeRatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRatesHash();

  @$internal
  @override
  ExchangeRates create() => ExchangeRates();
}

String _$exchangeRatesHash() => r'afc38b7d03830dd72ae0f05bb40a58414f6445ff';

abstract class _$ExchangeRates extends $AsyncNotifier<Map<String, double>> {
  FutureOr<Map<String, double>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, double>>, Map<String, double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<String, double>>, Map<String, double>>,
              AsyncValue<Map<String, double>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(fiatFormatter)
final fiatFormatterProvider = FiatFormatterProvider._();

final class FiatFormatterProvider
    extends
        $FunctionalProvider<
          String Function(double),
          String Function(double),
          String Function(double)
        >
    with $Provider<String Function(double)> {
  FiatFormatterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fiatFormatterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fiatFormatterHash();

  @$internal
  @override
  $ProviderElement<String Function(double)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function(double) create(Ref ref) {
    return fiatFormatter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function(double) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function(double)>(value),
    );
  }
}

String _$fiatFormatterHash() => r'09cb5e237d89eb9b60d309e80d487fd1be736345';
