import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trade_flow_provider.g.dart';

enum TradeFlowStage { input, review, processing, success, receipt }
enum TradeFlowType { deposit, withdraw, buy, sell, convert }

class TradeFlowState {
  final TradeFlowStage stage;
  final TradeFlowType type;
  
  const TradeFlowState({
    required this.stage,
    required this.type,
  });

  TradeFlowState copyWith({
    TradeFlowStage? stage,
    TradeFlowType? type,
  }) {
    return TradeFlowState(
      stage: stage ?? this.stage,
      type: type ?? this.type,
    );
  }
}

@riverpod
class TradeFlow extends _$TradeFlow {
  @override
  TradeFlowState build() {
    return const TradeFlowState(
      stage: TradeFlowStage.input,
      type: TradeFlowType.deposit,
    );
  }

  void setStage(TradeFlowStage newStage) {
    state = state.copyWith(stage: newStage);
  }

  void setType(TradeFlowType newType) {
    state = state.copyWith(type: newType);
  }
}
