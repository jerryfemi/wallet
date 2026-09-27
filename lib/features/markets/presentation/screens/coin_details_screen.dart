import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';

class CoinDetailsScreen extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinDetailsScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  coin.imageUrl,
                  width: 24,
                  height: 24,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 24),
                ),
                const SizedBox(width: 8),
                Text(coin.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                Text(
                  coin.symbol.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.star_border),
                onPressed: () {
                  // TODO: implement favorite toggle
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for Dynamic Price Header
                  Text(
                    '\$${coin.currentPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Placeholder for Charts
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: Text('Chart Placeholder')),
                  ),
                  const SizedBox(height: 32),

                  // Placeholder for Stats
                  Text('Market Stats', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  
                  // Placeholder for News
                  Text('News', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
