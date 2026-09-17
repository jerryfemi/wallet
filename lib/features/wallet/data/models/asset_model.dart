import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:wallet/features/wallet/domain/entities/asset_entity.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

/// Stores Decimal as a plain String in Firestore: "10000", "0.05" etc.
/// This avoids floating-point imprecision for financial amounts.
class _StringDecimalConverter implements JsonConverter<Decimal, dynamic> {
  const _StringDecimalConverter();

  @override
  Decimal fromJson(dynamic json) {
    if (json == null) return Decimal.zero;
    if (json is String) return Decimal.tryParse(json) ?? Decimal.zero;
    if (json is int) return Decimal.fromInt(json);
    if (json is double) return Decimal.parse(json.toString());
    return Decimal.zero;
  }

  @override
  String toJson(Decimal object) => object.toString();
}

@freezed
abstract class AssetModel with _$AssetModel {
  const AssetModel._();

  const factory AssetModel({
    required String coinId,
    required String symbol,
    @_StringDecimalConverter() required Decimal amount,
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
