import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_entity.freezed.dart';

@freezed
abstract class CoinEntity with _$CoinEntity {
  const factory CoinEntity({
    required String id,
    required String symbol,
    required String name,
    required String imageUrl,
    required double currentPrice,
    required double marketCap,
    required int marketCapRank,
    required double totalVolume,
    required double priceChangePercentage24h,
    required List<double> sparkline, // Empty list if no sparkline data
  }) = _CoinEntity;
}
