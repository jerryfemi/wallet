import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:wallet/shared/widgets/app_button.dart';

enum CustomSheetType {
  success,
  error;

  String get animationPath {
    switch (this) {
      case CustomSheetType.success:
        return 'assets/lottie/Success.json';
      case CustomSheetType.error:
        return 'assets/lottie/Error animation.json';
    }
  }
}

class CustomSheet extends StatelessWidget {
  final String title;
  final String message;
  final CustomSheetType type;
  final String buttonText;
  final VoidCallback? onPressed;

  const CustomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.buttonText = 'Continue',
    this.onPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required CustomSheetType type,
    String buttonText = 'Continue',
    VoidCallback? onPressed,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      StupidSimpleCupertinoSheetRoute(
        snappingConfig: SheetSnappingConfig([0.6]),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: CustomSheet(
          title: title,
          message: message,
          type: type,
          buttonText: buttonText,
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  type.animationPath,
                  width: 120,
                  height: 120,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color
                        ?.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: buttonText,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPressed != null) {
                      onPressed!();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
