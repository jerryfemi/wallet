import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class AnimatedTradeToggle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const AnimatedTradeToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleMotionBuilder(
      motion: CupertinoMotion.bouncy(),
      value: isExpanded ? 1.0 : 0.0,
      builder: (context, value, child) {
        // Value animates from 0.0 to 1.0 (with bounce overshoot)

        // Calculate container padding and color
        final horizontalPadding = 32.0 - (16.0 * value.clamp(0.0, 1.0));
        final bgColor = Color.lerp(
          colorScheme.primary,
          colorScheme.surfaceContainerHighest,
          value.clamp(0.0, 1.0),
        );
        final shadowOpacity = (0.3 * (1 - value)).clamp(0.0, 1.0);

        return GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                if (shadowOpacity > 0)
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: shadowOpacity),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            // Rotate the contents
            child: Transform.rotate(
              angle: value * 3.14159, // 180 degrees (Pi)
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: (1 - value * 2).clamp(0.0, 1.0),
                    child: Text(
                      'Trade',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: ((value - 0.5) * 2).clamp(0.0, 1.0),
                    child: Icon(
                      Icons.close_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
