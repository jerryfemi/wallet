import 'package:decimal/decimal.dart';

enum TransactionType { buy, sell, deposit, withdraw, transfer }

class TransactionEntity {
  final String id;
  final TransactionType type;
  final String assetSymbol;
  final Decimal amount;
  final Decimal fiatValue;
  final DateTime timestamp;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.assetSymbol,
    required this.amount,
    required this.fiatValue,
    required this.timestamp,
  });
}
