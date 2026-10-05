import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetSelectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  AssetSelectionHeaderDelegate({this.minHeight = 64.0, this.maxHeight = 64.0});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Add elevation/shadow when content scrolls under (overlapsContent is true)
    final elevation = overlapsContent ? 4.0 : 0.0;

    return Material(
      color: colorScheme.surfaceContainer,
      elevation: elevation,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(
                icon: Icons.close,
                color: colorScheme.surfaceContainerLow,
                onTap: () => Navigator.of(context).pop(),
              ),
              Text(
                'Select Asset',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _CircleButton(
                icon: Icons.check,
                color: colorScheme.primary.withValues(alpha: 0.8),
                iconColor: colorScheme.onPrimary,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant AssetSelectionHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
