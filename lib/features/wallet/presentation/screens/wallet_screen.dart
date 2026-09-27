import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/features/wallet/presentation/widgets/asset_balance_tile.dart';
import 'package:wallet/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:wallet/features/home/presentation/widgets/section_header.dart';
import 'package:wallet/features/wallet/presentation/widgets/portfolio_breakdown_card.dart';

import 'package:wallet/core/providers/exchange_rates_provider.dart';

class WalletScreen extends HookConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(portfolioAssetsProvider);
    final totalValueAsync = ref.watch(portfolioTotalValueProvider);
    final totalChangeAsync = ref.watch(portfolioTotalChange24hProvider);
    final formatFiat = ref.watch(fiatFormatterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              title: const Text('My Wallet'),
              actions: const [],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight + 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Estimated Total Value',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        totalValueAsync.when(
                          data: (value) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatFiat(value),
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 44,
                                    color: theme.colorScheme.onSurface,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                totalChangeAsync.when(
                                  data: (changePercent) {
                                    final changeValue =
                                        value * (changePercent / 100);
                                    final isPositive = changePercent >= 0;
                                    final color = isPositive
                                        ? Colors.green
                                        : Colors.red;
                                    final icon = isPositive ? '▲' : '▼';
                                    final prefix = isPositive ? '+' : '';

                                    return Text(
                                      '$icon $prefix${formatFiat(changeValue)} ($prefix${changePercent.toStringAsFixed(2)}%) today',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    );
                                  },
                                  loading: () => Skeletonizer(
                                    child: Text(
                                      '▲ +\$0.00 (+0.00%) today',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  error: (_, _) => const SizedBox(),
                                ),
                              ],
                            );
                          },
                          loading: () => Skeletonizer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$10,000.00',
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 44,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '▲ +\$0.00 (+0.00%) today',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          error: (_, _) => const Text('Error'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            // Optional refresh logic
          },
          child: CustomScrollView(
            slivers: [
              // Quick Actions
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: QuickActionsRow(),
                ),
              ),

              // Allocation Placeholder
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: 'Allocation'),
                      PortfolioBreakdownCard(),
                    ],
                  ),
                ),
              ),

              // Full Assets List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Assets'),
                      assetsAsync.when(
                        data: (assets) {
                          if (assets.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: Text('No assets found.')),
                            );
                          }
                          return Column(
                            children: assets
                                .map(
                                  (asset) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AssetBalanceTile(
                                      name: asset.name,
                                      symbol: asset.symbol,
                                      cryptoAmount: asset.amount,
                                      fiatAmount: asset.fiatValue,
                                      changePercentage:
                                          asset.changePercentage24h,
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
                        error: (_, _) =>
                            const Center(child: Text('Error loading assets')),
                      ),
                    ],
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
