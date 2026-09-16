import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/markets/data/models/coin_model.dart';
import 'package:wallet/core/utils/converters.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    required String id,
    required TransactionType type,
    required String assetSymbol,
    @DecimalConverter() required Decimal amount,
    @DecimalConverter() required Decimal fiatValue,
    @TimestampConverter() required DateTime timestamp,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      assetSymbol: entity.assetSymbol,
      amount: entity.amount,
      fiatValue: entity.fiatValue,
      timestamp: entity.timestamp,
    );
  }
}

extension TransactionModelX on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: type,
      assetSymbol: assetSymbol,
      amount: amount,
      fiatValue: fiatValue,
      timestamp: timestamp,
    );
  }
}
