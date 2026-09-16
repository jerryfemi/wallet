import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

import 'package:wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet/features/wallet/data/models/wallet_model.dart';
import 'package:wallet/features/wallet/data/models/asset_model.dart';
import 'package:wallet/features/wallet/data/models/transaction_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final FirebaseFirestore _firestore;

  WalletRepositoryImpl(this._firestore);

  @override
  Stream<WalletEntity?> watchWallet(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('main')
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      final model = WalletModel.fromJson(snapshot.data()!);
      return model.toEntity();
    });
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        final model = TransactionModel.fromJson(data);
        return model.toEntity();
      }).toList();
    });
  }

  @override
  Future<void> createInitialWallet(String userId) async {
    final walletRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('main');
        
    final doc = await walletRef.get();
    if (doc.exists) return; // Don't overwrite if it already exists

    final initialAsset = AssetModel(
      coinId: 'usd',
      symbol: 'USD',
      amount: Decimal.fromInt(10000), // $10,000 USD
    );

    final newWallet = WalletModel(
      userId: userId,
      assets: [initialAsset],
    );

    await walletRef.set(newWallet.toJson());
  }
}
