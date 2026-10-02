import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motor/motor.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/shared/widgets/trading_sheet.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_bottom_sheet.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';
import 'package:wallet/shared/widgets/action_pill.dart';
import 'package:wallet/features/markets/presentation/widgets/animated_trade_toggle.dart';

class TradeBottomBar extends HookConsumerWidget {
  final CoinEntity coin;

  const TradeBottomBar({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final isExpanded = useState(false);

    void toggleMenu() {
      HapticFeedback.lightImpact();
      isExpanded.value = !isExpanded.value;
    }

    void handleTrade(TradeFlowType type) {
      HapticFeedback.mediumImpact();
      isExpanded.value = false;
      
      ref.read(tradeFlowProvider.notifier).setType(type);
      ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.input);
      ref.read(tradeFlowProvider.notifier).setSelectedCoinId(coin.id);
      ref.read(tradeFlowProvider.notifier).setInputAmount(0);
      TradingSheet.show(context, child: const TradeBottomSheet());
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        if (isExpanded.value)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          
        Container(
          width: double.infinity,
          height: 80 + MediaQuery.paddingOf(context).bottom,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$1B traded today',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 120), 
            ],
          ),
        ),

        // Stacked Pills (Buy / Sell)
        Positioned(
          bottom: 70 + MediaQuery.paddingOf(context).bottom, 
          right: 24,
          child: SingleMotionBuilder(
            motion: CupertinoMotion.bouncy(),
            value: isExpanded.value ? 1.0 : 0.0,
            builder: (context, value, child) {
              if (value <= 0.01 && !isExpanded.value) return const SizedBox.shrink();
              
              final sellScale = ((value - 0.2) * (1 / 0.8)).clamp(0.0, 1.2);
              final buyScale = (value * (1 / 0.8)).clamp(0.0, 1.2);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: sellScale,
                    alignment: Alignment.bottomRight,
                    child: Opacity(
                      opacity: sellScale.clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ActionPill(
                          label: 'Sell',
                          color: colorScheme.errorContainer,
                          textColor: colorScheme.onErrorContainer,
                          onTap: () => handleTrade(TradeFlowType.sell),
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: buyScale,
                    alignment: Alignment.bottomRight,
                    child: Opacity(
                      opacity: buyScale.clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ActionPill(
                          label: 'Buy',
                          color: colorScheme.primary,
                          textColor: colorScheme.onPrimary,
                          onTap: () => handleTrade(TradeFlowType.buy),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        Positioned(
          bottom: 16 + MediaQuery.paddingOf(context).bottom,
          right: 24,
          child: AnimatedTradeToggle(
            isExpanded: isExpanded.value,
            onToggle: toggleMenu,
          ),
        ),
      ],
    );
  }
}
