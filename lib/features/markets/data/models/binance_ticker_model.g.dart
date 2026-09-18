// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binance_ticker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BinanceTickerModel _$BinanceTickerModelFromJson(Map<String, dynamic> json) =>
    _BinanceTickerModel(
      symbol: json['s'] as String,
      price: const DecimalConverter().fromJson(json['c']),
      priceChangePercent: const DecimalConverter().fromJson(json['P']),
    );

Map<String, dynamic> _$BinanceTickerModelToJson(_BinanceTickerModel instance) =>
    <String, dynamic>{
      's': instance.symbol,
      'c': const DecimalConverter().toJson(instance.price),
      'P': const DecimalConverter().toJson(instance.priceChangePercent),
    };
