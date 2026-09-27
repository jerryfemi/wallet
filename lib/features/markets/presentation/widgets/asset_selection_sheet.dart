import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

class AssetSelectionSheet extends HookConsumerWidget {
  final CoinEntity currentCoin;

  const AssetSelectionSheet({super.key, required this.currentCoin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false, // ensures it only takes the space it needs when placed in bottom sheet
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header (Fixed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // X Button
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    
                    // Title
                    Text(
                      'Select Asset',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Check Button
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check, color: theme.colorScheme.onPrimary),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable List
              Expanded(
                child: marketsAsync.when(
                  data: (coins) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: coins.length,
                      itemBuilder: (context, index) {
                        final coin = coins[index];
                        final isSelected = coin.id == currentCoin.id;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            if (!isSelected) {
                              Navigator.of(context).pop();
                              // Replace the current details route with the new coin
                              context.pushReplacement('${Routes.markets}/${Routes.coinDetails}', extra: coin);
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(coin.imageUrl),
                          ),
                          title: Text(
                            coin.symbol.toUpperCase(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            coin.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                  ? theme.colorScheme.primary 
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.transparent,
                            ),
                            child: isSelected 
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                )
                              : null,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
