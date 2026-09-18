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

enum DepositStage { input, processing, success, receipt }

class DepositBottomSheet extends HookConsumerWidget {
  const DepositBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = useState(DepositStage.input);
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
      // Use post-frame callback to ensure context is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = StupidSimpleSheetController.maybeOf<void>(context);
        if (controller == null) return;

        double target = 0.55;
        switch (stage.value) {
          case DepositStage.input:
            target = 0.55;
            break;
          case DepositStage.processing:
            target = 0.35;
            break;
          case DepositStage.success:
            target = 0.55;
            break;
          case DepositStage.receipt:
            target = 0.9;
            break;
        }

        controller.overrideSnappingConfig(
          SheetSnappingConfig([target], initialSnap: target),
          animateToComply: true,
        );
      });
      return null;
    }, [stage.value]);

    Future<void> onDepositSubmit(double amount) async {
      stage.value = DepositStage.processing;

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Execute the actual deposit
      await ref.read(simulateDepositProvider(amount).future);

      depositedAmount.value = amount;
      referenceNumber.value = generateRef();
      depositTime.value = DateTime.now();

      stage.value = DepositStage.success;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildCurrentStage(
        context,
        stage: stage,
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
    required ValueNotifier<DepositStage> stage,
    required TextEditingController amountController,
    required double depositedAmount,
    required String referenceNumber,
    required DateTime depositTime,
    required Future<void> Function(double) onSubmit,
  }) {
    switch (stage.value) {
      case DepositStage.input:
        return DepositInputView(
          key: const ValueKey('input'),
          amountController: amountController,
          onSubmit: onSubmit,
        );
      case DepositStage.processing:
        return const DepositProcessingView(key: ValueKey('processing'));
      case DepositStage.success:
        return DepositSuccessView(
          key: const ValueKey('success'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
          onViewReceipt: () => stage.value = DepositStage.receipt,
        );
      case DepositStage.receipt:
        return DepositReceiptView(
          key: const ValueKey('receipt'),
          amount: depositedAmount,
          referenceNumber: referenceNumber,
          depositTime: depositTime,
        );
    }
  }
}
