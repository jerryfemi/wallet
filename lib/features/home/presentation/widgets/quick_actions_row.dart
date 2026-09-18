import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wallet/shared/widgets/trading_sheet.dart';
import 'package:wallet/features/wallet/presentation/widgets/deposit_bottom_sheet.dart';

class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/deposit.svg',
            label: 'Deposit',
            onTap: () {
              TradingSheet.show(context, child: const DepositBottomSheet());
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconAsset: 'assets/icons/buy.svg',
            label: 'Buy',
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
  final VoidCallback onTap;

  const _ActionBtn({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconAsset,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
