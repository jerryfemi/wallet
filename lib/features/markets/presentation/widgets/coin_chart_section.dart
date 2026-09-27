import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_line_chart.dart';
import 'package:wallet/features/markets/presentation/widgets/coin_candlestick_chart.dart';

class CoinChartSection extends HookConsumerWidget {
  final CoinEntity coin;

  const CoinChartSection({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCandle = ref.watch(isCandleChartProvider);
    final selectedTimeframe = ref.watch(chartTimeframeProvider);

    return Column(
      children: [
        // Chart Area
        SizedBox(
          height: 300,
          width: double.infinity,
          child: isCandle
              ? CoinCandlestickChart(coin: coin)
              : CoinLineChart(coin: coin),
        ),
        
        const SizedBox(height: 16),
        
        // Controls Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Timeframes
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['1D', '1W', '1M', '1Y', 'ALL'].map((tf) {
                    final isSelected = selectedTimeframe == tf;
                    return GestureDetector(
                      onTap: () {
                        ref.read(chartTimeframeProvider.notifier).setTimeframe(tf);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tf,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Toggle Chart Mode
            IconButton(
              icon: Icon(isCandle ? Icons.show_chart : Icons.candlestick_chart),
              onPressed: () {
                ref.read(isCandleChartProvider.notifier).toggle();
              },
            ),
          ],
        ),
      ],
    );
  }
}
