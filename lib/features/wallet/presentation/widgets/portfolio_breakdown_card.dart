import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wallet/app/theme/chart_colors.dart';
import 'package:wallet/core/providers/exchange_rates_provider.dart';
import 'package:wallet/features/wallet/presentation/providers/wallet_provider.dart';

class PortfolioBreakdownCard extends HookConsumerWidget {
  const PortfolioBreakdownCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assetsAsync = ref.watch(portfolioAssetsProvider);
    final formatFiat = ref.watch(fiatFormatterProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: assetsAsync.when(
        skipLoadingOnReload: true,
        data: (assets) {
          if (assets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Deposit funds to see your portfolio breakdown'),
              ),
            );
          }

          final totalValue = assets.fold<double>(
            0.0,
            (sum, asset) => sum + asset.fiatValue,
          );

          if (totalValue == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No value in portfolio'),
              ),
            );
          }

          // Calculate Cash vs Crypto
          double cashValue = 0;
          double cryptoValue = 0;

          for (final asset in assets) {
            if (asset.coinId == 'tether') {
              cashValue += asset.fiatValue;
            } else {
              cryptoValue += asset.fiatValue;
            }
          }

          final cashPercentage = (cashValue / totalValue) * 100;
          final cryptoPercentage = (cryptoValue / totalValue) * 100;

          // Prepare Donut Chart Data
          final List<PieChartSectionData> sections = [];

          for (int i = 0; i < assets.length; i++) {
            final asset = assets[i];
            final percentage = (asset.fiatValue / totalValue) * 100;

            // Only show sections for non-zero percentages (or > 1% to avoid clutter)
            if (percentage > 0) {
              sections.add(
                PieChartSectionData(
                  value: asset.fiatValue,
                  color: ChartColors.forCoin(asset.coinId, i),
                  radius: 24,
                  showTitle: false,
                ),
              );
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Donut Chart
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 36,
                            sections: sections,
                          ),
                        ),
                        // Center Text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${assets.length}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Assets',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Legend
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: assets.take(4).toList().asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final asset = entry.value;
                        final percentage = (asset.fiatValue / totalValue) * 100;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ChartColors.forCoin(
                                    asset.coinId,
                                    index,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  asset.symbol.toUpperCase(),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Cash vs Crypto Summary
              _buildSummaryRow(
                context,
                title: 'Cash (USDT)',
                value: formatFiat(cashValue),
                percentage: cashPercentage,
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                context,
                title: 'Crypto',
                value: formatFiat(cryptoValue),
                percentage: cryptoPercentage,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Error loading portfolio data')),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String title,
    required String value,
    required double percentage,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                textAlign: TextAlign.right,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
