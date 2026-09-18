import 'package:decimal/decimal.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';

class BinanceTickerModel {
  final String symbol;
  final Decimal price;
  final Decimal priceChangePercent;

  const BinanceTickerModel({
    required this.symbol,
    required this.price,
    required this.priceChangePercent,
  });

  factory BinanceTickerModel.fromJson(Map<String, dynamic> json) {
    return BinanceTickerModel(
      symbol: json['s'] as String,
      price: Decimal.parse(json['c'] as String),
      priceChangePercent: Decimal.parse(json['P'] as String),
    );
  }

  TickerUpdateEntity toEntity() {
    return TickerUpdateEntity(
      // We convert "BTCUSDT" to "btc" here to match CoinGecko's format
      symbol: symbol.toLowerCase().replaceAll('usdt', ''),
      price: price,
      priceChangePercentage24h: priceChangePercent,
    );
  }
}
