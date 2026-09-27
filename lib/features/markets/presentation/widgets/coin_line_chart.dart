import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_details_provider.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';

class CoinLineChart extends ConsumerWidget {
  final CoinEntity coin;

  const CoinLineChart({super.key, required this.coin});

  // Map timeframe to Coinbase granularity (in seconds)
  String _mapTimeframeToGranularity(String timeframe) {
    switch (timeframe) {
      case '1D':
        return '900'; // 15m
      case '1W':
        return '3600'; // 1h
      case '1M':
        return '21600'; // 6h
      case '1Y':
        return '86400'; // 1d
      case 'ALL':
        return '86400';
      default:
        return '900';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeframe = ref.watch(chartTimeframeProvider);
    final granularity = _mapTimeframeToGranularity(timeframe);
    final scrubbedData = ref.watch(scrubbedChartDataProvider);
    
    // We use coin.symbol since Coinbase expects something like BTC-USD
    final candlesAsync = ref.watch(
      coinCandlesProvider(coin.symbol, granularity),
    );

    return candlesAsync.when(
      data: (candles) {
        if (candles.isEmpty) {
          return const Center(child: Text('No chart data available'));
        }

        // Coinbase returns newest first. Reverse for fl_chart (oldest to newest on X axis).
        final reversedCandles = candles.reversed.toList();

        // Determine color based on open/close of the entire visible period
        final firstCandle = reversedCandles.first;
        final lastCandle = reversedCandles.last;
        final isPositive = lastCandle.close >= firstCandle.open;
        final chartColor = isPositive ? Colors.greenAccent : Colors.redAccent;

        final spots = reversedCandles.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.close);
        }).toList();

        final minY = reversedCandles
            .map((c) => c.low)
            .reduce((a, b) => a < b ? a : b);
        final maxY = reversedCandles
            .map((c) => c.high)
            .reduce((a, b) => a > b ? a : b);
        final yPadding = (maxY - minY) * 0.1;
        
        // Calculate mask percentage for the retraction effect
        double maskPercent = 1.0; // Default fully active
        if (scrubbedData != null && scrubbedData.index != null && spots.length > 1) {
          maskPercent = scrubbedData.index! / (spots.length - 1);
        }

        return LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: spots.length.toDouble() - 1,
            minY: minY - yPadding,
            maxY: maxY + yPadding,
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: firstCandle.open,
                    color: Colors.white24,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ],
              ),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                  if (!context.mounted) return;
                  
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.lineBarSpots == null) {
                    // User stopped scrubbing, clear scrubbed data
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        ref.read(scrubbedChartDataProvider.notifier).clear();
                      }
                    });
                    return;
                  }
                  final spotIndex = response.lineBarSpots!.first.spotIndex;
                  final candle = reversedCandles[spotIndex];

                  // Update the state provider so the header updates instantly
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      ref
                          .read(scrubbedChartDataProvider.notifier)
                          .setScrubbed(
                            candle.close,
                            candle.date,
                            openPrice: firstCandle.open,
                            index: spotIndex,
                          );
                    }
                  });
                },
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          const FlLine(
                            color: Colors.white54,
                            strokeWidth: 1.5,
                            // Solid vertical line
                          ),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: chartColor,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                        );
                      }).toList();
                    },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Colors.transparent,
                  tooltipPadding: const EdgeInsets.only(bottom: 8),
                  tooltipMargin: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final date = reversedCandles[spot.spotIndex].date;
                      // Format like "2:32 PM"
                      final timeString = "${date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour)}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
                      
                      return LineTooltipItem(
                        timeString,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.2, // Premium rounded feel
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                gradient: LinearGradient(
                  colors: [
                    chartColor,
                    chartColor.withValues(alpha: 0.2), // Dimmed section after touch point
                  ],
                  // Hard stop right at the touch point!
                  stops: [maskPercent, maskPercent],
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      chartColor.withValues(alpha: 0.25),
                      chartColor.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading chart: $e')),
    );
  }
}
