import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/features/wallet/data/models/asset_model.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const WalletModel._();

  const factory WalletModel({
    required String userId,
    @Default([]) List<AssetModel> assets,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);

  factory WalletModel.fromEntity(WalletEntity entity) {
    return WalletModel(
      userId: entity.userId,
      assets: entity.assets.map((a) => AssetModel.fromEntity(a)).toList(),
    );
  }
}

extension WalletModelX on WalletModel {
  WalletEntity toEntity() {
    return WalletEntity(
      userId: userId,
      assets: assets.map((a) => a.toEntity()).toList(),
    );
  }
}
