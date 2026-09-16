import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/asset_entity.dart';
import '../../../markets/data/models/coin_model.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
abstract class AssetModel with _$AssetModel {
  const AssetModel._();

  const factory AssetModel({
    required String coinId,
    required String symbol,
    @DecimalConverter() required Decimal amount,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);

  factory AssetModel.fromEntity(AssetEntity entity) {
    return AssetModel(
      coinId: entity.coinId,
      symbol: entity.symbol,
      amount: entity.amount,
    );
  }
}

extension AssetModelX on AssetModel {
  AssetEntity toEntity() {
    return AssetEntity(
      coinId: coinId,
      symbol: symbol,
      amount: amount,
    );
  }
}
