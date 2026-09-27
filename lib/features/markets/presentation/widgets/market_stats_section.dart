import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/core/utils/formatters.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';
import 'package:wallet/app/router/routes.dart';
import 'package:wallet/core/presentation/widgets/bouncy_touch.dart';

class MarketStatsSection extends StatelessWidget {
  final CoinEntity coin;

  const MarketStatsSection({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    // Derived values
    final currentPrice = coin.currentPrice.toDouble();
    final marketCap = coin.marketCap.toDouble();
    final volume = coin.totalVolume.toDouble();
    final circulatingSupply = currentPrice > 0 ? marketCap / currentPrice : 0.0;

    double high24h = currentPrice;
    double low24h = currentPrice;

    if (coin.sparkline.isNotEmpty) {
      high24h = coin.sparkline.reduce(max);
      low24h = coin.sparkline.reduce(min);
      high24h = max(high24h, currentPrice);
      low24h = min(low24h, currentPrice);
    }

    final compactNumberFormat = NumberFormat.compact(locale: 'en_US');
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BouncyTouch(
          onTap: () {
            context.push('/markets/${Routes.coinDetails}/${Routes.aboutCoin}', extra: coin);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'About ${coin.name}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${coin.name} is a decentralized digital asset and cryptocurrency that enables peer-to-peer transactions on its network without the need for a central authority.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Stats List wrapped in a single BouncyTouch
        BouncyTouch(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  context,
                  label: 'Market cap',
                  value: Formatters.formatCompactFiat(marketCap),
                ),
                _buildStatRow(
                  context,
                  label: '24h Volume',
                  value: Formatters.formatCompactFiat(volume),
                ),
                _buildStatRow(
                  context,
                  label: 'Circulating Supply',
                  value: '${compactNumberFormat.format(circulatingSupply)} ${coin.symbol.toUpperCase()}',
                ),
                _buildStatRow(
                  context,
                  label: '24h Range',
                  value: '${Formatters.formatCompactFiat(low24h)} - ${Formatters.formatCompactFiat(high24h)}',
                ),
                _buildStatRow(
                  context,
                  label: 'Market Cap Rank',
                  value: '#${coin.marketCapRank}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, {required String label, required String value}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
