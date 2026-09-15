import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/markets_provider.dart';
import '../widgets/coin_list_tile.dart';
import '../../domain/entities/coin_entity.dart';

class MarketsScreen extends HookConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsState = ref.watch(marketsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(marketsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(marketsProvider.notifier).refresh();
        },
        child: marketsState.when(
          data: (coins) => _buildList(coins, isLoading: false),
          loading: () => _buildList(_getDummyData(), isLoading: true),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                Text('Failed to load markets:\n$error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(marketsProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<CoinEntity> coins, {required bool isLoading}) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coins.length,
        itemBuilder: (context, index) {
          final coin = coins[index];
          return CoinListTile(coin: coin);
        },
      ),
    );
  }

  // Dummy data specifically for the Skeletonizer to paint over
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
        sparkline: [1, 2, 1, 3, 2, 4, 3, 5],
      ),
    );
  }
}
