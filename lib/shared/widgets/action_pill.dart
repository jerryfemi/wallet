import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  const ActionPill({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedColor = color ?? colorScheme.surfaceContainer;
    final resolvedTextColor = textColor ?? colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      elevation: color != null ? 4 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        onTap: () {
          // Add haptic feedback as requested
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: resolvedColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: resolvedTextColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: resolvedTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
