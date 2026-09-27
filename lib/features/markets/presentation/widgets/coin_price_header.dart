import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';
import 'package:wallet/core/providers/exchange_rates_provider.dart';

class CoinPriceHeader extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinPriceHeader({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrubbedData = ref.watch(scrubbedChartDataProvider);
    final formatFiat = ref.watch(fiatFormatterProvider);

    // Determine current display values
    final double displayPrice =
        scrubbedData?.price ?? coin.currentPrice.toDouble();

    Decimal displayChange;
    if (scrubbedData != null &&
        scrubbedData.openPrice != null &&
        scrubbedData.openPrice! > 0) {
      final diff = scrubbedData.price - scrubbedData.openPrice!;
      final pct = (diff / scrubbedData.openPrice!) * 100;
      displayChange = Decimal.parse(pct.toStringAsFixed(2));
    } else {
      displayChange = coin.priceChangePercentage24h;
    }

    final isPositive = displayChange >= Decimal.zero;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatFiat(displayPrice),
          style: Theme.of(context).textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color,
            ),
            Text(
              '${displayChange.abs().toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            if (scrubbedData != null) ...[
              const SizedBox(width: 12),
              Text(
                _formatTime(scrubbedData.time),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    // Simple format: e.g. "Oct 12, 14:30"
    return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
