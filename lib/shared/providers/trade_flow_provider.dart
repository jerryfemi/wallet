import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trade_flow_provider.g.dart';

enum TradeFlowStage {
  assetSelection,
  input,
  review,
  processing,
  success,
  receipt,
  failed,
}

enum TradeFlowType { deposit, withdraw, buy, sell, convert }

class TradeFlowState {
  final TradeFlowStage stage;
  final TradeFlowType type;
  final String? selectedCoinId;
  final double? inputAmount;
  final String? errorMessage;

  const TradeFlowState({
    required this.stage,
    required this.type,
    this.selectedCoinId,
    this.inputAmount,
    this.errorMessage,
  });

  TradeFlowState copyWith({
    TradeFlowStage? stage,
    TradeFlowType? type,
    String? selectedCoinId,
    double? inputAmount,
    String? errorMessage,
  }) {
    return TradeFlowState(
      stage: stage ?? this.stage,
      type: type ?? this.type,
      selectedCoinId: selectedCoinId ?? this.selectedCoinId,
      inputAmount: inputAmount ?? this.inputAmount,
      errorMessage: errorMessage ?? this.errorMessage,
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

  void setStage(TradeFlowStage newStage, {String? errorMessage}) {
    state = state.copyWith(stage: newStage, errorMessage: errorMessage);
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

  void setErrorMessage(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }
}
