// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoinModel _$CoinModelFromJson(Map<String, dynamic> json) => _CoinModel(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  currentPrice: const DecimalConverter().fromJson(json['current_price']),
  marketCap: const DecimalConverter().fromJson(json['market_cap']),
  marketCapRank: (json['market_cap_rank'] as num).toInt(),
  totalVolume: const DecimalConverter().fromJson(json['total_volume']),
  priceChangePercentage24h: const DecimalConverter().fromJson(
    json['price_change_percentage_24h'],
  ),
  sparklineIn7d: json['sparkline_in_7d'] == null
      ? null
      : SparklineModel.fromJson(
          json['sparkline_in_7d'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CoinModelToJson(_CoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'current_price': const DecimalConverter().toJson(instance.currentPrice),
      'market_cap': const DecimalConverter().toJson(instance.marketCap),
      'market_cap_rank': instance.marketCapRank,
      'total_volume': const DecimalConverter().toJson(instance.totalVolume),
      'price_change_percentage_24h': const DecimalConverter().toJson(
        instance.priceChangePercentage24h,
      ),
      'sparkline_in_7d': instance.sparklineIn7d,
    };

_SparklineModel _$SparklineModelFromJson(Map<String, dynamic> json) =>
    _SparklineModel(
      price: (json['price'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$SparklineModelToJson(_SparklineModel instance) =>
    <String, dynamic>{'price': instance.price};
