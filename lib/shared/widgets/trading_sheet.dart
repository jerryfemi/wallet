import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

class TradingSheet extends StatelessWidget {
  final Widget child;

  const TradingSheet({
    super.key,
    required this.child,
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context).push(
      StupidSimpleCupertinoSheetRoute<T>(
        snappingConfig: SheetSnappingConfig(
          [0.5, 0.9],
          initialSnap: 0.5,
        ),
        child: TradingSheet(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetBackground(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // The main content provided by the specific flow (Deposit/Buy/Sell)
            Positioned.fill(
              child: child,
            ),
            
            // "Exit full screen" / "Minimize" button at top left, visible if we want
            Positioned(
              top: 16,
              left: 16,
              child: Builder(
                builder: (ctx) {
                  return IconButton(
                    icon: const Icon(Icons.close_fullscreen),
                    onPressed: () {
                      final controller = StupidSimpleSheetController.maybeOf<void>(ctx);
                      controller?.animateToRelative(0.5, snap: true);
                    },
                    tooltip: 'Minimize',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
