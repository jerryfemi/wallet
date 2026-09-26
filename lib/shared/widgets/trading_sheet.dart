import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

/// A non-dismissible sheet route that overrides the default barrier behavior.
class _NonDismissibleSheetRoute<T> extends StupidSimpleCupertinoSheetRoute<T> {
  _NonDismissibleSheetRoute({
    required super.child,
    required super.snappingConfig,
    required super.shape,
  });

  @override
  bool get barrierDismissible => false;
}

/// A reusable sheet wrapper for Deposit, Buy, and Sell flows.
/// Uses StupidSimpleCupertinoSheetRoute with snapping support.
class TradingSheet extends StatelessWidget {
  final Widget child;

  const TradingSheet({super.key, required this.child});

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context, rootNavigator: true).push(
      _NonDismissibleSheetRoute<T>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        snappingConfig: SheetSnappingConfig([0.6, 0.9], initialSnap: 0.6),
        child: TradingSheet(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
