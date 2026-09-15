import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';

part 'coin_entity.freezed.dart';

@freezed
abstract class CoinEntity with _$CoinEntity {
  const factory CoinEntity({
    required String id,
    required String symbol,
    required String name,
    required String imageUrl,
    required Decimal currentPrice,
    required Decimal marketCap,
    required int marketCapRank,
    required Decimal totalVolume,
    required Decimal priceChangePercentage24h,
    required List<double> sparkline, // Empty list if no sparkline data
  }) = _CoinEntity;
}
