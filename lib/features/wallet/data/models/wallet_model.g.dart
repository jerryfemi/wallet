// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  userId: json['userId'] as String,
  address: json['address'] as String? ?? '0xCS_LEGACY_WALLET_RECREATE_ACCOUNT',
  assets:
      (json['assets'] as List<dynamic>?)
          ?.map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'address': instance.address,
      'assets': instance.assets,
    };
