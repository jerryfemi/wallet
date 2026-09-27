import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_chart_section.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_sliver_header_delegate.dart';
import 'package:wallet/features/markets/presentation/widgets/market_stats_section.dart';

class CoinDetailsScreen extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinDetailsScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: CoinSliverHeaderDelegate(
              coin: coin,
              expandedHeight: 240.0,
              collapsedHeight:
                  kToolbarHeight + MediaQuery.paddingOf(context).top,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Charts
                  CoinChartSection(coin: coin),
                  const SizedBox(height: 32),

                  MarketStatsSection(coin: coin),
                  const SizedBox(height: 32),

                  // Placeholder for News
                  Text('News', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          SliverFillRemaining(hasScrollBody: true),
        ],
      ),
    );
  }
}
