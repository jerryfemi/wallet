import 'package:decimal/decimal.dart';
import 'asset_entity.dart';

class WalletEntity {
  final String userId;
  final List<AssetEntity> assets;

  const WalletEntity({
    required this.userId,
    required this.assets,
  });

  /// Helper to get the amount of a specific asset
  Decimal getAssetAmount(String coinId) {
    try {
      return assets.firstWhere((a) => a.coinId == coinId).amount;
    } catch (e) {
      return Decimal.zero;
    }
  }
}
