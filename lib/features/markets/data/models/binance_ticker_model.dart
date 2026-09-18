import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';
import 'package:wallet/features/markets/domain/entities/ticker_update_entity.dart';
import 'package:wallet/features/markets/data/models/coin_model.dart';

part 'binance_ticker_model.freezed.dart';
part 'binance_ticker_model.g.dart';

@freezed
abstract class BinanceTickerModel with _$BinanceTickerModel {
  const BinanceTickerModel._();

  const factory BinanceTickerModel({
    @JsonKey(name: 's') required String symbol,
    @DecimalConverter() @JsonKey(name: 'c') required Decimal price,
    @DecimalConverter() @JsonKey(name: 'P') required Decimal priceChangePercent,
  }) = _BinanceTickerModel;

  factory BinanceTickerModel.fromJson(Map<String, dynamic> json) =>
      _$BinanceTickerModelFromJson(json);

  TickerUpdateEntity toEntity() {
    return TickerUpdateEntity(
      symbol: symbol.toLowerCase().replaceAll('usdt', ''),
      price: price,
      priceChangePercentage24h: priceChangePercent,
    );
  }
}
