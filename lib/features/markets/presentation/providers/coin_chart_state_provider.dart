import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_chart_state_provider.g.dart';

class ScrubbedData {
  final double price;
  final DateTime time;
  final double? openPrice; // For percentage change calculation
  final int? index; // The index of the scrubbed candle for chart masking

  ScrubbedData(this.price, this.time, {this.openPrice, this.index});
}

@riverpod
class ScrubbedChartData extends _$ScrubbedChartData {
  @override
  ScrubbedData? build() => null;

  void setScrubbed(double price, DateTime time, {double? openPrice, int? index}) {
    state = ScrubbedData(price, time, openPrice: openPrice, index: index);
  }

  void clear() {
    state = null;
  }
}

@riverpod
class ChartTimeframe extends _$ChartTimeframe {
  @override
  String build() => '1D';

  void setTimeframe(String tf) {
    state = tf;
  }
}

@riverpod
class IsCandleChart extends _$IsCandleChart {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}
