import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_list_tile.dart';
import 'package:wallet/shared/providers/trade_flow_provider.dart';

class AssetSelectionView extends HookConsumerWidget {
  const AssetSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final marketsState = ref.watch(marketsProvider);
    final markets = marketsState.value ?? [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const SizedBox(width: 48), // Balance close button
                Expanded(
                  child: Text(
                    'Select Asset',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (markets.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: markets.length,
                  itemBuilder: (context, index) {
                    final coin = markets[index];
                    // Filter out tether since it's the base currency for simulated buys
                    if (coin.id == 'tether') return const SizedBox.shrink();
                    
                    return InkWell(
                      onTap: () {
                        ref.read(tradeFlowProvider.notifier).setSelectedCoinId(coin.id);
                        ref.read(tradeFlowProvider.notifier).setStage(TradeFlowStage.input);
                      },
                      child: CoinListTile(
                        coin: coin,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
