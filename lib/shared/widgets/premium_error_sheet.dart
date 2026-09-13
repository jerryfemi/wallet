import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';
import 'app_button.dart';

class PremiumErrorSheet extends StatelessWidget {
  final String title;
  final String message;

  const PremiumErrorSheet({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<void> show(BuildContext context, {required String title, required String message}) {
    return Navigator.of(context).push(
      StupidSimpleSheetRoute(
        child: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: PremiumErrorSheet(title: title, message: message),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetBackground(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Dismiss',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
