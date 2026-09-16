// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      assetSymbol: json['assetSymbol'] as String,
      amount: const DecimalConverter().fromJson(json['amount']),
      fiatValue: const DecimalConverter().fromJson(json['fiatValue']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'assetSymbol': instance.assetSymbol,
      'amount': const DecimalConverter().toJson(instance.amount),
      'fiatValue': const DecimalConverter().toJson(instance.fiatValue),
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.buy: 'buy',
  TransactionType.sell: 'sell',
  TransactionType.deposit: 'deposit',
  TransactionType.withdraw: 'withdraw',
  TransactionType.transfer: 'transfer',
};
