import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';

class CompactCoinPriceHeader extends ConsumerWidget {
  final CoinEntity coin;

  const CompactCoinPriceHeader({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrubbedData = ref.watch(scrubbedChartDataProvider);
    final displayPrice = scrubbedData?.price ?? coin.currentPrice.toDouble();

    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coin.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          currencyFormatter.format(displayPrice),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
