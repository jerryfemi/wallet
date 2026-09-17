// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => _AssetModel(
  coinId: json['coinId'] as String,
  symbol: json['symbol'] as String,
  amount: const _StringDecimalConverter().fromJson(json['amount']),
);

Map<String, dynamic> _$AssetModelToJson(_AssetModel instance) =>
    <String, dynamic>{
      'coinId': instance.coinId,
      'symbol': instance.symbol,
      'amount': const _StringDecimalConverter().toJson(instance.amount),
    };
