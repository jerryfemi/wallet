import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_model.freezed.dart';
part 'coin_model.g.dart';

@freezed
abstract class CoinModel with _$CoinModel {
  const factory CoinModel({
    required String id,
    required String symbol,
    required String name,
    required String image,
    @JsonKey(name: 'current_price') required double currentPrice,
    @JsonKey(name: 'market_cap') required double marketCap,
    @JsonKey(name: 'market_cap_rank') required int marketCapRank,
    @JsonKey(name: 'total_volume') required double totalVolume,
    @JsonKey(name: 'price_change_percentage_24h') required double priceChangePercentage24h,
    @JsonKey(name: 'sparkline_in_7d') SparklineModel? sparklineIn7d,
  }) = _CoinModel;

  factory CoinModel.fromJson(Map<String, dynamic> json) => _$CoinModelFromJson(json);
}

@freezed
abstract class SparklineModel with _$SparklineModel {
  const factory SparklineModel({
    required List<double> price,
  }) = _SparklineModel;

  factory SparklineModel.fromJson(Map<String, dynamic> json) => _$SparklineModelFromJson(json);
}
