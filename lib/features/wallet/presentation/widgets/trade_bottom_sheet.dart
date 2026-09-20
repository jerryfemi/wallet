import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_input_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_processing_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_success_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_views/deposit_receipt_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_views/asset_selection_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_views/buy_input_view.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_views/trade_review_view.dart';

class TradeBottomSheet extends HookConsumerWidget {
  const TradeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(tradeFlowProvider);

    // Deposit state
    final amountController = useTextEditingController();
    final depositedAmount = useState(0.0);

    // Common state
    final referenceNumber = useState('');
    final tradeTime = useState(DateTime.now());

    String generateRef() {
      final rand = Random();
      return '#TX-${rand.nextInt(90000) + 10000}';
    }

    // Animate sheet height
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = StupidSimpleSheetController.maybeOf<void>(context);
        if (controller == null) return;

        double target = 0.55;

        // Dynamic targeting based on stage and flow type
        switch (flowState.stage) {
          case TradeFlowStage.input:
            // Asset selection might need a slightly larger input size or just default
            target =
                (flowState.type == TradeFlowType.buy &&
                    flowState.selectedCoinId == null)
                ? 0.7
                : 0.6;
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
    }, [flowState.stage, flowState.type, flowState.selectedCoinId]);

    Future<void> onDepositSubmit(double amount) async {
      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.processing);
      await Future.delayed(const Duration(seconds: 2));
      depositedAmount.value = amount;
      referenceNumber.value = generateRef();
      tradeTime.value = DateTime.now();
      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.success);
      await Future.delayed(const Duration(milliseconds: 300));
      await ref.read(simulateDepositProvider(amount).future);
    }

    Future<void> onBuyConfirm(
      String coinId,
      String symbol,
      double cryptoAmount,
      double executionPrice,
    ) async {
      // Already in processing state from the Review View
      await Future.delayed(const Duration(seconds: 2));

      referenceNumber.value = generateRef();
      tradeTime.value = DateTime.now();

      final user = ref.read(authStateProvider).value;
      if (user != null) {
        // Execute trade via backend repository
        await ref
            .read(walletRepositoryProvider)
            .executeTrade(
              userId: user.uid,
              type: TransactionType.buy,
              coinId: coinId,
              symbol: symbol,
              cryptoAmount: cryptoAmount,
              executionPrice: executionPrice,
            );
      }

      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.success);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildCurrentStage(
        context,
        flowState: flowState,
        ref: ref,
        amountController: amountController,
        depositedAmount: depositedAmount.value,
        referenceNumber: referenceNumber.value,
        tradeTime: tradeTime.value,
        onDepositSubmit: onDepositSubmit,
        onBuyConfirm: onBuyConfirm,
      ),
    );
  }

  Widget _buildCurrentStage(
    BuildContext context, {
    required TradeFlowState flowState,
    required WidgetRef ref,
    required TextEditingController amountController,
    required double depositedAmount,
    required String referenceNumber,
    required DateTime tradeTime,
    required Future<void> Function(double) onDepositSubmit,
    required Future<void> Function(String, String, double, double) onBuyConfirm,
  }) {
    switch (flowState.stage) {
      case TradeFlowStage.input:
        if (flowState.type == TradeFlowType.deposit) {
          return DepositInputView(
            key: const ValueKey('deposit_input'),
            amountController: amountController,
            onSubmit: onDepositSubmit,
          );
        } else if (flowState.type == TradeFlowType.buy) {
          if (flowState.selectedCoinId == null) {
            return const AssetSelectionView(key: ValueKey('asset_selection'));
          } else {
            return const BuyInputView(key: ValueKey('buy_input'));
          }
        }
        return const SizedBox.shrink();

      case TradeFlowStage.review:
        if (flowState.type == TradeFlowType.buy) {
          return TradeReviewView(
            key: const ValueKey('buy_review'),
            onConfirm: onBuyConfirm,
          );
        }
        return const SizedBox.shrink();

      case TradeFlowStage.processing:
        return const DepositProcessingView(key: ValueKey('processing'));

      case TradeFlowStage.success:
        return DepositSuccessView(
          key: const ValueKey('success'),
          amount: flowState.type == TradeFlowType.deposit
              ? depositedAmount
              : (flowState.inputAmount ?? 0.0),
          referenceNumber: referenceNumber,
          depositTime: tradeTime,
          onViewReceipt: () => ref
              .read(tradeFlowProvider.notifier)
              .setStage(TradeFlowStage.receipt),
        );

      case TradeFlowStage.receipt:
        return DepositReceiptView(
          key: const ValueKey('receipt'),
          amount: flowState.type == TradeFlowType.deposit
              ? depositedAmount
              : (flowState.inputAmount ?? 0.0),
          referenceNumber: referenceNumber,
          depositTime: tradeTime,
        );
    }
  }
}
