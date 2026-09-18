import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:wallet/features/home/presentation/widgets/home_header.dart';
import 'package:wallet/features/home/presentation/widgets/total_balance_card.dart';
import 'package:wallet/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:wallet/features/home/presentation/widgets/section_header.dart';
import 'package:wallet/features/wallet/presentation/widgets/asset_balance_tile.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:decimal/decimal.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(portfolioAssetsProvider);
    final totalValueAsync = ref.watch(portfolioTotalValueProvider);
    final totalChangeAsync = ref.watch(portfolioTotalChange24hProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Optional refresh logic here if needed
          },
          child: CustomScrollView(
            slivers: [
              // Header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: HomeHeader(),
                ),
              ),

              // Total Balance Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: totalValueAsync.when(
                    data: (totalValue) {
                      final change = totalChangeAsync.value ?? 0.0;
                      return TotalBalanceCard(
                        totalValue: totalValue,
                        percentageChange: change,
                      );
                    },
                    loading: () => Skeletonizer(
                      child: TotalBalanceCard(
                        totalValue: 10000.0,
                        percentageChange: 2.5,
                      ),
                    ),
                    error: (e, st) =>
                        const Center(child: Text('Error loading balance')),
                  ),
                ),
              ),

              // Quick Actions
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: QuickActionsRow(),
                ),
              ),

              // Your Holdings Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Your Holdings',
                    actionLabel: 'See All',
                    onActionTap: () {
                      // context.go('/wallet'); // Go to wallet tab
                    },
                  ),
                ),
              ),

              // Top 3 Holdings List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: assetsAsync.when(
                    data: (assets) {
                      if (assets.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your wallet is empty',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Deposit USDT to get started with simulated trading.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Take only top 3
                      final topAssets = assets.take(3).toList();

                      return Column(
                        children: topAssets
                            .map(
                              (asset) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AssetBalanceTile(
                                  name: asset.name,
                                  symbol: asset.symbol,
                                  cryptoAmount: asset.amount,
                                  fiatAmount: asset.fiatValue,
                                  changePercentage: asset.changePercentage24h,
                                  iconUrl: asset.imageUrl,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => Skeletonizer(
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AssetBalanceTile(
                              name: 'Loading...',
                              symbol: 'LOD',
                              cryptoAmount: Decimal.one,
                              fiatAmount: 1000.0,
                              changePercentage: 0.0,
                              iconUrl: '',
                            ),
                          ),
                        ),
                      ),
                    ),
                    error: (e, st) =>
                        const Center(child: Text('Error loading assets')),
                  ),
                ),
              ),

              // Recent Activity Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: SectionHeader(
                    title: 'Recent Activity',
                    actionLabel: 'See All',
                    onActionTap: () {
                      // Navigate to transactions
                    },
                  ),
                ),
              ),

              // Recent Activity List (Top 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: transactionsAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No recent activity',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      final topTransactions = transactions.take(3).toList();

                      return Column(
                        children: topTransactions.map((tx) {
                          final isDeposit = tx.type.name == 'deposit';
                          final formattedAmount = NumberFormat.currency(symbol: '\$').format(tx.amount.toDouble());
                          final formattedDate = DateFormat('MMM d, y, h:mm a').format(tx.timestamp);
                          final typeName = tx.type.name[0].toUpperCase() + tx.type.name.substring(1);
                          
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: isDeposit ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                              child: Icon(
                                isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isDeposit ? Colors.green.shade400 : Colors.red.shade400,
                              ),
                            ),
                            title: Text('$typeName ${tx.assetSymbol}'),
                            subtitle: Text(formattedDate),
                            trailing: Text(
                              '${isDeposit ? '+' : '-'}$formattedAmount',
                              style: TextStyle(
                                color: isDeposit ? Colors.green.shade400 : Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) =>
                        const Center(child: Text('Error loading activity')),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
