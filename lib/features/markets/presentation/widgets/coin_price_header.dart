import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';

class CoinPriceHeader extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinPriceHeader({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrubbedData = ref.watch(scrubbedChartDataProvider);

    // Determine current display values
    final double displayPrice =
        scrubbedData?.price ?? coin.currentPrice.toDouble();

    Decimal displayChange;
    Decimal displayDollarChange;

    if (scrubbedData != null &&
        scrubbedData.openPrice != null &&
        scrubbedData.openPrice! > 0) {
      final diff = scrubbedData.price - scrubbedData.openPrice!;
      final pct = (diff / scrubbedData.openPrice!) * 100;
      displayChange = Decimal.parse(pct.toStringAsFixed(2));
      displayDollarChange = Decimal.parse(diff.toStringAsFixed(2));
    } else {
      displayChange = Decimal.parse(coin.priceChangePercentage24h.toStringAsFixed(2));
      final double price = coin.currentPrice.toDouble();
      final double pctDouble = coin.priceChangePercentage24h.toDouble();
      final double open = price / (1 + (pctDouble / 100));
      displayDollarChange = Decimal.parse((price - open).toStringAsFixed(2));
    }

    final isPositive = displayChange >= Decimal.zero;
    final color = isPositive ? Colors.greenAccent : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              coin.name,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Custom per-character Odometer instead of external package to avoid network/CORS issues
        Row(
          mainAxisSize: MainAxisSize.min,
          children: _formatOdometer(displayPrice).split('').asMap().entries.map(
            (entry) {
              final index = entry.key;
              final char = entry.value;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation = Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(animation);

                  final outAnimation = Tween<Offset>(
                    begin: const Offset(0.0, -0.5),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: child.key == ValueKey(char)
                          ? inAnimation
                          : outAnimation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  char,
                  // Combine index and character to force animation only on changed digits
                  key: ValueKey('$index$char'),
                  style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 44, letterSpacing: -1.5),
                ),
              );
            },
          ).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          '${isPositive ? '+' : '-'}\$${displayDollarChange.abs().toDouble().toStringAsFixed(1)} (${isPositive ? '+' : ''}${displayChange.toDouble().toStringAsFixed(2)}%)',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _formatOdometer(double price) {
    // Convert to string with 2 decimal places and add commas
    final parts = price.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];

    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedWhole = whole.replaceAllMapped(reg, (Match m) => '${m[1]},');

    return '\$$formattedWhole.$decimal';
  }
}
