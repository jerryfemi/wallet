import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/shared/widgets/trading_sheet.dart';
import 'package:wallet/features/wallet/presentation/widgets/trade_bottom_sheet.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class TradeBottomBar extends HookConsumerWidget {
  final CoinEntity coin;

  const TradeBottomBar({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Animation controller for the expandable menu
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final isExpanded = useState(false);

    // Toggle menu state
    void toggleMenu() {
      HapticFeedback.lightImpact();
      if (isExpanded.value) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
      isExpanded.value = !isExpanded.value;
    }

    void handleTrade(TradeFlowType type) {
      HapticFeedback.mediumImpact();
      // Close the menu
      animationController.reverse();
      isExpanded.value = false;
      
      // Launch trade sheet
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
        // Invisible barrier to close menu when tapping outside
        if (isExpanded.value)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          
        // The Sticky Bottom Bar Background
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
            color: colorScheme.surface, // Solid color as requested
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
              // Contextual Info
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
              
              // Spacing for the main button
              const SizedBox(width: 120), 
            ],
          ),
        ),

        // Stacked Pills (Buy / Sell)
        Positioned(
          bottom: 80 + MediaQuery.paddingOf(context).bottom + 16, // Above the bottom bar
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sell Pill
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.2, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _ActionPill(
                      label: 'Sell',
                      color: colorScheme.errorContainer,
                      textColor: colorScheme.onErrorContainer,
                      onTap: () => handleTrade(TradeFlowType.sell),
                    ),
                  ),
                ),
              ),
              
              // Buy Pill
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.0, 0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _ActionPill(
                      label: 'Buy',
                      color: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                      onTap: () => handleTrade(TradeFlowType.buy),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Original Trade Pill (morphs to X)
        Positioned(
          bottom: 16 + MediaQuery.paddingOf(context).bottom,
          right: 24,
          child: GestureDetector(
            onTap: toggleMenu,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded.value ? 16.0 : 32.0,
                vertical: 14.0,
              ),
              decoration: BoxDecoration(
                color: isExpanded.value
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
                boxShadow: isExpanded.value
                    ? []
                    : [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: isExpanded.value
                    ? Icon(
                        Icons.close_rounded,
                        key: const ValueKey('close'),
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      )
                    : Text(
                        'Trade',
                        key: const ValueKey('trade'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionPill({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
