import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wallet/shared/widgets/trading_sheet.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_bottom_sheet.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/asset_selection_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';

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
              ref
                  .read(tradeFlowProvider.notifier)
                  .setType(TradeFlowType.deposit);
              ref
                  .read(tradeFlowProvider.notifier)
                  .setStage(TradeFlowStage.input);
              TradingSheet.show(context, child: const TradeBottomSheet());
            },
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
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconData: Icons.send_rounded,
            label: 'Send',
            onTap: () {
              TradingSheet.show(
                context,
                child: AssetSelectionSheet(
                  onSelect: (coin) {
                    context.push('${Routes.send}/${coin.id}', extra: coin);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionBtn(
            iconData: Icons.qr_code_2_rounded,
            label: 'Receive',
            onTap: () {
              TradingSheet.show(
                context,
                child: AssetSelectionSheet(
                  onSelect: (coin) {
                    context.push('${Routes.receive}/${coin.id}', extra: coin);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String? iconAsset;
  final IconData? iconData;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({
    this.iconAsset,
    this.iconData,
    required this.label,
    required this.onTap,
  }) : assert(iconAsset != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
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
              if (iconAsset != null)
                SvgPicture.asset(
                  iconAsset!,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                )
              else if (iconData != null)
                Icon(iconData, color: colorScheme.onSurface, size: 20),
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
