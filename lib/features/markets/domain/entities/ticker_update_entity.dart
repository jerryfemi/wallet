import 'package:decimal/decimal.dart';

class TickerUpdateEntity {
  final String symbol;
  final Decimal price;
  final Decimal priceChangePercentage24h;

  const TickerUpdateEntity({
    required this.symbol,
    required this.price,
    required this.priceChangePercentage24h,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TickerUpdateEntity &&
      other.symbol == symbol &&
      other.price == price &&
      other.priceChangePercentage24h == priceChangePercentage24h;
  }

  @override
  int get hashCode => symbol.hashCode ^ price.hashCode ^ priceChangePercentage24h.hashCode;
}
