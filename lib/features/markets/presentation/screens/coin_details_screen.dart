import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_price_header.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_chart_section.dart';

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
                  // Dynamic Price Header
                  CoinPriceHeader(coin: coin),
                  const SizedBox(height: 32),
                  
                  // Charts
                  CoinChartSection(coin: coin),
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
