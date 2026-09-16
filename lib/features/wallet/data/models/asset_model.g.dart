// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => _AssetModel(
  coinId: json['coinId'] as String,
  symbol: json['symbol'] as String,
  amount: const DecimalConverter().fromJson(json['amount']),
);

Map<String, dynamic> _$AssetModelToJson(_AssetModel instance) =>
    <String, dynamic>{
      'coinId': instance.coinId,
      'symbol': instance.symbol,
      'amount': const DecimalConverter().toJson(instance.amount),
    };
