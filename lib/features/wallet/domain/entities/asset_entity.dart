import 'package:decimal/decimal.dart';

class AssetEntity {
  final String coinId; // e.g. "bitcoin" or "usd"
  final String symbol; // e.g. "BTC" or "USD"
  final Decimal amount; // Quantity held

  const AssetEntity({
    required this.coinId,
    required this.symbol,
    required this.amount,
  });
}
