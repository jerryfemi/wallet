import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_list_tile.dart';
import 'package:wallet/features/markets/presentation/widgets/top_mover_chip.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';

class MarketsScreen extends HookConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the filtered list for the main body
    final filteredMarketsState = ref.watch(filteredMarketsProvider);
    final topMoversState = ref.watch(topMoversProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(marketsProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Top Bar
            SliverAppBar(
              pinned: true,
              expandedHeight: 112, // Standard height for a large/medium app bar
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.1, // Matches default M3 expanded size (~24px)
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Markets',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 22, // Matches default M3 pinned size
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).updateQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search coin...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer
                          .withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top Movers
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  'Top Movers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 64, // Increased height to prevent bottom overflow
                child: topMoversState.when(
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  data: (movers) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: movers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return TopMoverChip(
                        key: ValueKey(movers[index].id),
                        coin: movers[index],
                        onTap: () {
                          // TODO: open details
                        },
                      );
                    },
                  ),
                  loading: () => Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return TopMoverChip(
                          coin: const MarketsScreen()._getDummyData()[index],
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  error: (error, stack) => const SizedBox(),
                ),
              ),
            ),

            // Filter Pills
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterPillsDelegate(
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      const _FilterPill(label: 'All', filter: MarketFilter.all),
                      const SizedBox(width: 8),
                      const _FilterPill(
                        label: 'Gainers',
                        filter: MarketFilter.gainers,
                      ),
                      const SizedBox(width: 8),
                      const _FilterPill(
                        label: 'Losers',
                        filter: MarketFilter.losers,
                      ),
                      const SizedBox(width: 8),
                      const _FilterPill(
                        label: 'Volume',
                        filter: MarketFilter.volume,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main List
            filteredMarketsState.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (coins) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CoinListTile(
                      key: ValueKey(coins[index].id),
                      coin: coins[index],
                    ),
                    childCount: coins.length,
                  ),
                ),
              ),
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Skeletonizer(
                      enabled: true,
                      child: CoinListTile(coin: _getDummyData()[index]),
                    ),
                    childCount: 10,
                  ),
                ),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Market data is unavailable.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your connection and pull to refresh.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CoinEntity> _getDummyData() {
    return List.generate(
      10,
      (index) => CoinEntity(
        id: 'dummy_$index',
        symbol: 'DUMMY',
        name: 'Loading Coin',
        imageUrl: '',
        currentPrice: Decimal.parse('99999.99'),
        marketCap: Decimal.parse('1000000.0'),
        marketCapRank: 1,
        totalVolume: Decimal.parse('10000.0'),
        priceChangePercentage24h: Decimal.parse('5.0'),
        sparkline: const [1, 2, 1, 3, 2, 4, 3, 5],
      ),
    );
  }
}

class _FilterPillsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterPillsDelegate({required this.child});

  @override
  double get minExtent => 56.0;

  @override
  double get maxExtent => 56.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _FilterPillsDelegate oldDelegate) =>
      oldDelegate.child != child;
}

class _FilterPill extends HookConsumerWidget {
  final String label;
  final MarketFilter filter;

  const _FilterPill({required this.label, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeMarketFilterProvider);
    final isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(activeMarketFilterProvider.notifier).setFilter(filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer
                    .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  double get minExtent => 68;

  @override
  double get maxExtent => 68;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
