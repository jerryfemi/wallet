import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trade_flow_provider.g.dart';

enum TradeFlowStage { input, review, processing, success, receipt }
enum TradeFlowType { deposit, withdraw, buy, sell, convert }

class TradeFlowState {
  final TradeFlowStage stage;
  final TradeFlowType type;
  final String? selectedCoinId;
  final double? inputAmount;
  
  const TradeFlowState({
    required this.stage,
    required this.type,
    this.selectedCoinId,
    this.inputAmount,
  });

  TradeFlowState copyWith({
    TradeFlowStage? stage,
    TradeFlowType? type,
    String? selectedCoinId,
    double? inputAmount,
  }) {
    return TradeFlowState(
      stage: stage ?? this.stage,
      type: type ?? this.type,
      selectedCoinId: selectedCoinId ?? this.selectedCoinId,
      inputAmount: inputAmount ?? this.inputAmount,
    );
  }
}

@Riverpod(keepAlive: true)
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
  
  void setSelectedCoinId(String? coinId) {
    state = state.copyWith(selectedCoinId: coinId);
  }
  
  void setInputAmount(double? amount) {
    state = state.copyWith(inputAmount: amount);
  }
}
