import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

/// A reusable sheet wrapper for Deposit, Buy, and Sell flows.
/// Uses StupidSimpleCupertinoSheetRoute with snapping support.
class TradingSheet extends StatelessWidget {
  final Widget child;

  const TradingSheet({super.key, required this.child});

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context, rootNavigator: true).push(
      StupidSimpleCupertinoSheetRoute<T>(
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
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
