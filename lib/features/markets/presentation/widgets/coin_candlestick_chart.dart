import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:wallet/features/markets/domain/entities/coin_entity.dart';
import 'package:wallet/features/markets/presentation/providers/coin_details_provider.dart';
import 'package:wallet/features/markets/presentation/providers/coin_chart_state_provider.dart';

import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';

class CoinCandlestickChart extends ConsumerWidget {
  final CoinEntity coin;

  const CoinCandlestickChart({super.key, required this.coin});

  // Map timeframe to Coinbase granularity (in seconds)
  String _mapTimeframeToGranularity(String timeframe) {
    switch (timeframe) {
      case 'Live':
        return '60'; // 1m
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
    final livePrice = ref.watch(livePricesProvider)[coin.symbol]?.price;

    // We use coin.symbol since Coinbase expects something like BTC-USD
    final candlesAsync = ref.watch(
      coinCandlesProvider(coin.symbol, granularity),
    );

    return candlesAsync.when(
      data: (candles) {
        if (candles.isEmpty) {
          return const Center(child: Text('No chart data available'));
        }

        // Copy the list to avoid mutating state directly
        final mutableCandles = List<Candle>.from(candles);

        // If Live mode, we inject the latest real-time tick to the newest candle (index 0)
        if (timeframe == 'Live' && livePrice != null && mutableCandles.isNotEmpty) {
          final first = mutableCandles[0];
          final current = livePrice.toDouble();
          mutableCandles[0] = Candle(
            date: first.date,
            high: current > first.high ? current : first.high,
            low: current < first.low ? current : first.low,
            open: first.open,
            close: current,
            volume: first.volume,
          );
        }

        return Theme(
          // Customize the Candlesticks theme to match our app
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.transparent,
          ),
          child: Candlesticks(
            candles: mutableCandles,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading chart: $e')),
    );
  }
}
