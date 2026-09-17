import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/deposit.svg',
            label: 'Deposit',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/buy.svg',
            label: 'Buy',
            isPrimary: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/sell.svg',
            label: 'Sell',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/withdraw.svg',
            label: 'Withdraw',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String iconAsset;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.iconAsset,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = isPrimary
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final iconBgColor = isPrimary
        ? Colors.white.withValues(alpha: 0.2)
        : colorScheme.primary;
    final iconColor = isPrimary ? colorScheme.onPrimary : colorScheme.onPrimary;
    final textColor = isPrimary ? colorScheme.onPrimary : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBgColor,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconAsset,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
