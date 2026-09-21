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
        snappingConfig: SheetSnappingConfig([0.5, 0.9], initialSnap: 0.5),
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
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Sheet content
            Expanded(
              child: SafeArea(top: false, child: child),
            ),
          ],
        ),
      ),
    );
  }
}
