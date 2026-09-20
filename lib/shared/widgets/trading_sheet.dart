import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

/// A reusable sheet wrapper for Deposit, Buy, and Sell flows.
/// Uses StupidSimpleCupertinoSheetRoute with snapping support.
class TradingSheet extends ConsumerWidget {
  final Widget child;

  const TradingSheet({super.key, required this.child});

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context, rootNavigator: true).push(
      StupidSimpleCupertinoSheetRoute<T>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        snappingConfig: SheetSnappingConfig([0.5, 0.9], initialSnap: 0.5),
        child: TradingSheet(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(tradeFlowProvider);
    final isFullScreen = flowState.stage == TradeFlowStage.review ||
        flowState.stage == TradeFlowStage.receipt;

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: isFullScreen
              ? BorderRadius.zero
              : const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(top: false, child: child),
        ),
      ),
    );
  }
}
