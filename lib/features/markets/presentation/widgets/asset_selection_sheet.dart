import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

class AssetSelectionSheet extends HookConsumerWidget {
  final CoinEntity? currentCoin;
  final void Function(CoinEntity)? onSelect;

  const AssetSelectionSheet({super.key, this.currentCoin, this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const headerHeight = 64.0;

    return Stack(
      children: [
        // Scrollable grouped list — fills full area, padded at top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: marketsAsync.when(
            data: (coins) => _GroupedCoinList(
              coins: coins,
              selectedId: currentCoin?.id,
              topPadding: headerHeight + 12,
              onTap: (coin) {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                if (onSelect != null) {
                  onSelect!(coin);
                } else {
                  context.pushReplacement(Routes.coinDetails, extra: coin);
                }
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),

        // Floating header — sits on top, casts shadow when content scrolls under
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            color: colorScheme.surfaceContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: headerHeight,
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
          ),
        ),
      ],
    );
  }
}

// --- Private widgets ---

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

class _GroupedCoinList extends StatelessWidget {
  final List<CoinEntity> coins;
  final String? selectedId;
  final double topPadding;
  final void Function(CoinEntity) onTap;

  const _GroupedCoinList({
    required this.coins,
    required this.selectedId,
    required this.topPadding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      margin: EdgeInsets.only(top: topPadding),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: coins.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          thickness: 1,
          color: theme.dividerColor.withValues(alpha: 0.1),
          indent: 56,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final coin = coins[index];
          final isSelected = coin.id == selectedId;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(coin),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        coin.imageUrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.symbol.toUpperCase(),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            coin.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RadioDot(isSelected: isSelected),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  const _RadioDot({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).colorScheme.onSurface
        .withValues(alpha: 0.3);

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? primary : muted, width: 2),
        color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary,
                ),
              ),
            )
          : null,
    );
  }
}
