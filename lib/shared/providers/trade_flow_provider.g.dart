// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_flow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TradeFlow)
final tradeFlowProvider = TradeFlowProvider._();

final class TradeFlowProvider
    extends $NotifierProvider<TradeFlow, TradeFlowState> {
  TradeFlowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tradeFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tradeFlowHash();

  @$internal
  @override
  TradeFlow create() => TradeFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TradeFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TradeFlowState>(value),
    );
  }
}

String _$tradeFlowHash() => r'a53641938f2caedab1785bc44ef8670d243ce0e0';

abstract class _$TradeFlow extends $Notifier<TradeFlowState> {
  TradeFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TradeFlowState, TradeFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TradeFlowState, TradeFlowState>,
              TradeFlowState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
