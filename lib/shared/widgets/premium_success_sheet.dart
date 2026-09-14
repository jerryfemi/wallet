import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'app_button.dart';

class PremiumSuccessSheet extends StatelessWidget {
  final String title;
  final String message;

  const PremiumSuccessSheet({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return Navigator.of(context).push(
      StupidSimpleSheetRoute(
        child: PremiumSuccessSheet(title: title, message: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SheetBackground(
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
                    'assets/lottie/checklist.json',
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
                    text: 'Continue',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
