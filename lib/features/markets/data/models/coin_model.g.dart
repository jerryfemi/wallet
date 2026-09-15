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
  currentPrice: (json['current_price'] as num?)?.toDouble(),
  marketCap: (json['market_cap'] as num?)?.toDouble(),
  marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
  totalVolume: (json['total_volume'] as num?)?.toDouble(),
  priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)
      ?.toDouble(),
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
      'current_price': instance.currentPrice,
      'market_cap': instance.marketCap,
      'market_cap_rank': instance.marketCapRank,
      'total_volume': instance.totalVolume,
      'price_change_percentage_24h': instance.priceChangePercentage24h,
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
