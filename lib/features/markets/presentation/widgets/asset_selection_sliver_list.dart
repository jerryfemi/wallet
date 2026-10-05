import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';

class AssetSelectionSliverList extends StatelessWidget {
  final List<CoinEntity> coins;
  final String? selectedId;
  final void Function(CoinEntity) onTap;

  const AssetSelectionSliverList({
    super.key,
    required this.coins,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainerHigh;
    final dividerColor = theme.dividerColor.withValues(alpha: 0.1);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          final coin = coins[index];
          final isSelected = coin.id == selectedId;

          final isFirst = index == 0;
          final isLast = index == coins.length - 1;

          return Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.vertical(
                top: isFirst ? const Radius.circular(28) : Radius.zero,
                bottom: isLast ? const Radius.circular(28) : Radius.zero,
              ),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(coin),
                    borderRadius: BorderRadius.vertical(
                      top: isFirst ? const Radius.circular(28) : Radius.zero,
                      bottom: isLast ? const Radius.circular(28) : Radius.zero,
                    ),
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
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: dividerColor,
                    indent: 56,
                    endIndent: 16,
                  ),
              ],
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
