import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';

part 'coin_model.freezed.dart';
part 'coin_model.g.dart';

class DecimalConverter implements JsonConverter<Decimal, dynamic> {
  const DecimalConverter();

  @override
  Decimal fromJson(dynamic json) {
    if (json == null) return Decimal.zero;
    if (json is String) return Decimal.tryParse(json) ?? Decimal.zero;
    if (json is int) return Decimal.fromInt(json);
    if (json is double) return Decimal.parse(json.toString());
    return Decimal.zero;
  }

  @override
  dynamic toJson(Decimal object) => object.toDouble();
}

@freezed
abstract class CoinModel with _$CoinModel {
  const factory CoinModel({
    required String id,
    required String symbol,
    required String name,
    required String image,
    @DecimalConverter() @JsonKey(name: 'current_price') required Decimal currentPrice,
    @DecimalConverter() @JsonKey(name: 'market_cap') required Decimal marketCap,
    @JsonKey(name: 'market_cap_rank') required int marketCapRank,
    @DecimalConverter() @JsonKey(name: 'total_volume') required Decimal totalVolume,
    @DecimalConverter() @JsonKey(name: 'price_change_percentage_24h') required Decimal priceChangePercentage24h,
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
