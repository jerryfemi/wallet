import 'package:flutter/material.dart';

class TradeFailedDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const TradeFailedDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: colorScheme.error,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onDismiss,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Dismiss',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
