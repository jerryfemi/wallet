import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:wallet/features/wallet/presentation/widgets/asset_balance_tile.dart';
import 'package:wallet/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:wallet/features/home/presentation/widgets/section_header.dart';
import 'package:wallet/core/utils/formatters.dart';

class WalletScreen extends HookConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(portfolioAssetsProvider);
    final totalValueAsync = ref.watch(portfolioTotalValueProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 220.0,
              title: const Text(
                'My Wallet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainer,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
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
                          data: (value) => Text(
                            Formatters.formatFiat(value),
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          loading: () => Skeletonizer(
                            child: Text(
                              '\$10,000.00',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Allocation'),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            // Placeholder for Donut Chart
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 12,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  assetsAsync.value?.length.toString() ?? '0',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Portfolio breakdown',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Visual chart coming soon in the polish phase!',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
