// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_chart_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScrubbedChartData)
final scrubbedChartDataProvider = ScrubbedChartDataProvider._();

final class ScrubbedChartDataProvider
    extends $NotifierProvider<ScrubbedChartData, ScrubbedData?> {
  ScrubbedChartDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scrubbedChartDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scrubbedChartDataHash();

  @$internal
  @override
  ScrubbedChartData create() => ScrubbedChartData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScrubbedData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScrubbedData?>(value),
    );
  }
}

String _$scrubbedChartDataHash() => r'bc230dd01f65f0d272db064bba7204e71264af93';

abstract class _$ScrubbedChartData extends $Notifier<ScrubbedData?> {
  ScrubbedData? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScrubbedData?, ScrubbedData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScrubbedData?, ScrubbedData?>,
              ScrubbedData?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ChartTimeframe)
final chartTimeframeProvider = ChartTimeframeProvider._();

final class ChartTimeframeProvider
    extends $NotifierProvider<ChartTimeframe, String> {
  ChartTimeframeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartTimeframeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartTimeframeHash();

  @$internal
  @override
  ChartTimeframe create() => ChartTimeframe();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$chartTimeframeHash() => r'9b5d15bea22fecc4304451400adf108713c3807c';

abstract class _$ChartTimeframe extends $Notifier<String> {
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

@ProviderFor(IsCandleChart)
final isCandleChartProvider = IsCandleChartProvider._();

final class IsCandleChartProvider
    extends $NotifierProvider<IsCandleChart, bool> {
  IsCandleChartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isCandleChartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isCandleChartHash();

  @$internal
  @override
  IsCandleChart create() => IsCandleChart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isCandleChartHash() => r'a163fcf1869920ce50252afbd2eee6e5ad07c3e5';

abstract class _$IsCandleChart extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
