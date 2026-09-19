import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

class CoinListTile extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinListTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Select precisely this coin's update from the massive Map.
    // Riverpod's `select` ensures this tile ONLY rebuilds if its specific coin's price changes!
    final ticker = ref.watch(
      livePricesProvider.select((map) => map[coin.symbol.toUpperCase()]),
    );

    final currentPrice = ticker?.price ?? coin.currentPrice;
    final priceChange =
        ticker?.priceChangePercentage24h ??
        coin.priceChangePercentage24h;

    final isPositive = priceChange >= Decimal.zero;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    final flashColor = useState<Color?>(null);

    ref.listen(
      livePricesProvider.select((map) => map[coin.symbol.toUpperCase()]),
      (previous, next) {
      final nextPrice = next?.price;
      final prevPrice = previous?.price ?? coin.currentPrice;

      if (nextPrice != null && nextPrice != prevPrice) {
        flashColor.value = nextPrice > prevPrice
            ? Colors.greenAccent
            : Colors.redAccent;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) flashColor.value = null;
        });
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Coin Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Skeleton.replace(
              width: 48,
              height: 48,
              child: kIsWeb
                  ? Image.network(
                      coin.imageUrl,
                      width: 48,
                      height: 48,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(Icons.error),
                          ),
                    )
                  : CachedNetworkImage(
                      imageUrl: coin.imageUrl,
                      width: 48,
                      height: 48,
                      placeholder: (context, url) =>
                          const SizedBox(width: 48, height: 48),
                      errorWidget: (context, url, error) => const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.error),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Name and Symbol
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  coin.symbol,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Sparkline Chart
          if (coin.sparkline.isNotEmpty)
            Expanded(
              flex: 3,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Skeleton.ignore(
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: coin.sparkline.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value);
                          }).toList(),
                          isCurved: true,
                          color: color,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: color.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            const Expanded(flex: 3, child: SizedBox(height: 40)),

          const SizedBox(width: 16),

          // Price and Change
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        flashColor.value ??
                        Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  child: Text('\$${currentPrice.toStringAsFixed(2)}'),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: color,
                      size: 18,
                    ),
                    Text(
                      '${priceChange.abs().toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
