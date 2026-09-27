import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/core/utils/formatters.dart';
import 'package:intl/intl.dart';

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
      // Ensure current price is within bounds (mock data can sometimes be slightly off)
      high24h = max(high24h, currentPrice);
      low24h = min(low24h, currentPrice);
    }

    final compactNumberFormat = NumberFormat.compact(locale: 'en_US');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _StatCard(
              title: 'MARKET CAP',
              value: Formatters.formatCompactFiat(marketCap),
              badgeText: '#${coin.marketCapRank}',
            ),
            _StatCard(
              title: '24H VOLUME',
              value: Formatters.formatCompactFiat(volume),
            ),
            _StatCard(
              title: 'CIRCULATING SUPPLY',
              value: '${compactNumberFormat.format(circulatingSupply)} ${coin.symbol.toUpperCase()}',
            ),
            _RangeStatCard(
              title: '24H RANGE',
              low: low24h,
              high: high24h,
              current: currentPrice,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? badgeText;

  const _StatCard({
    required this.title,
    required this.value,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RangeStatCard extends StatelessWidget {
  final String title;
  final double low;
  final double high;
  final double current;

  const _RangeStatCard({
    required this.title,
    required this.low,
    required this.high,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final range = high - low;
    final ratio = range == 0 ? 0.5 : ((current - low) / range).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          // Range Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // Track
                  Container(
                    height: 4,
                    width: barWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Progress indicator
                  Positioned(
                    left: (barWidth * ratio) - 4, // Center the dot
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          // High / Low labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.formatCompactFiat(low),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Formatters.formatCompactFiat(high),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
