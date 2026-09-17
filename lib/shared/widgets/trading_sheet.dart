import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

class TradingSheet extends StatelessWidget {
  final Widget child;

  const TradingSheet({
    super.key,
    required this.child,
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context, rootNavigator: true).push(
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
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: SheetBackground(
        // Let SheetBackground handle the surface color
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Main content
              SafeArea(
                top: false,
                child: child,
              ),
              
              // "Minimize" / "Exit full screen" button at top left
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
      ),
    );
  }
}
