import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_input_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_processing_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_success_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_receipt_view.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class DepositBottomSheet extends HookConsumerWidget {
  const DepositBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(tradeFlowProvider);
    final amountController = useTextEditingController();
    final depositedAmount = useState(0.0);
    final referenceNumber = useState('');
    final depositTime = useState(DateTime.now());

    // Generate a random reference number on deposit
    String generateRef() {
      final rand = Random();
      return '#TX-${rand.nextInt(90000) + 10000}';
    }

    // Animate sheet height when stage changes
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = StupidSimpleSheetController.maybeOf<void>(context);
        if (controller == null) return;

        double target = 0.55;
        switch (flowState.stage) {
          case TradeFlowStage.input:
            target = 0.55;
            break;
          case TradeFlowStage.review:
            target = 1.0;
            break;
          case TradeFlowStage.processing:
            target = 0.35;
            break;
          case TradeFlowStage.success:
            target = 0.55;
            break;
          case TradeFlowStage.receipt:
            target = 1.0;
            break;
        }

        controller.overrideSnappingConfig(
          SheetSnappingConfig([target], initialSnap: target),
          animateToComply: true,
        );
      });
      return null;
    }, [flowState.stage]);

    Future<void> onDepositSubmit(double amount) async {
      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.processing);

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      depositedAmount.value = amount;
      referenceNumber.value = generateRef();
      depositTime.value = DateTime.now();

      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.success);

      // Update the actual balance after showing success
      await Future.delayed(const Duration(milliseconds: 300));
      await ref.read(simulateDepositProvider(amount).future);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildCurrentStage(
        context,
        stage: flowState.stage,
        ref: ref,
        amountController: amountController,
        depositedAmount: depositedAmount.value,
        referenceNumber: referenceNumber.value,
        depositTime: depositTime.value,
        onSubmit: onDepositSubmit,
      ),
    );
  }

  Widget _buildCurrentStage(
    BuildContext context, {
    required TradeFlowStage stage,
    required WidgetRef ref,
    required TextEditingController amountController,
    required double depositedAmount,
    required String referenceNumber,
    required DateTime depositTime,
    required Future<void> Function(double) onSubmit,
  }) {
    switch (stage) {
      case TradeFlowStage.input:
        return DepositInputView(
          key: const ValueKey('input'),
          amountController: amountController,
          onSubmit: onSubmit,
        );
      case TradeFlowStage.review:
      case TradeFlowStage.processing:
        return const DepositProcessingView(key: ValueKey('processing'));
      case TradeFlowStage.success:
        return DepositSuccessView(
          key: const ValueKey('success'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
          onViewReceipt: () => ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.receipt),
        );
      case TradeFlowStage.receipt:
        return DepositReceiptView(
          key: const ValueKey('receipt'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
        );
    }
  }
}
