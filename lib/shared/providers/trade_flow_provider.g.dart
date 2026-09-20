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

String _$tradeFlowHash() => r'34b5d48fbb1b8f20f407dad8c43a7d4539a4f67d';

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
