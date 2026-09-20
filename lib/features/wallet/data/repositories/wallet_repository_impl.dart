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

    final newWallet = WalletModel(
      userId: userId,
      assets: [], // Start with an empty wallet
    );

    final walletJson = newWallet.toJson();
    walletJson['assets'] = newWallet.assets.map((a) => a.toJson()).toList();

    await walletRef.set(walletJson);
  }

  @override
  Future<void> simulateDeposit(String userId, double amount) async {
    final walletRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('main');

    final doc = await walletRef.get();
    if (!doc.exists) return;

    final wallet = WalletModel.fromJson(doc.data()!);
    final List<AssetModel> updatedAssets = List.from(wallet.assets);

    // Find tether (USDT)
    final existingIndex = updatedAssets.indexWhere((a) => a.coinId == 'tether');

    if (existingIndex >= 0) {
      final existing = updatedAssets[existingIndex];
      final newAmount = existing.amount + Decimal.parse(amount.toString());
      updatedAssets[existingIndex] = existing.copyWith(amount: newAmount);
    } else {
      updatedAssets.add(
        AssetModel(
          coinId: 'tether',
          symbol: 'USDT',
          amount: Decimal.parse(amount.toString()),
        ),
      );
    }

    final walletJson = wallet.copyWith(assets: updatedAssets).toJson();
    walletJson['assets'] = updatedAssets.map((a) => a.toJson()).toList();

    // 1. Update wallet
    await walletRef.set(walletJson);

    // 2. Add transaction record
    final txRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc();

    final tx = TransactionModel(
      id: txRef.id,
      type: TransactionType.deposit,
      assetSymbol: 'USDT',
      amount: Decimal.parse(amount.toString()),
      fiatValue: Decimal.parse(
        amount.toString(),
      ), // 1 USDT ~= 1 USD for deposit sim
      timestamp: DateTime.now(),
    );

    await txRef.set(tx.toJson());
  }

  @override
  Future<void> executeTrade({
    required String userId,
    required TransactionType type,
    required String coinId,
    required String symbol,
    required double cryptoAmount,
    required double executionPrice,
  }) async {
    final walletRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('main');
    
    final txRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc();

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(walletRef);
      if (!doc.exists || doc.data() == null) {
        throw Exception('Wallet not found');
      }

      final wallet = WalletModel.fromJson(doc.data()!);
      final List<AssetModel> updatedAssets = List.from(wallet.assets);
      
      final usdtIndex = updatedAssets.indexWhere((a) => a.coinId == 'tether');
      final targetIndex = updatedAssets.indexWhere((a) => a.coinId == coinId);
      
      final usdtAsset = usdtIndex >= 0 ? updatedAssets[usdtIndex] : null;
      final targetAsset = targetIndex >= 0 ? updatedAssets[targetIndex] : null;

      final double fiatValue = cryptoAmount * executionPrice;
      final double fee = fiatValue * 0.01; // 1% fee

      if (type == TransactionType.buy) {
        final double totalCost = fiatValue + fee;
        if (usdtAsset == null || usdtAsset.amount.toDouble() < totalCost) {
          throw Exception('Insufficient USDT balance');
        }
        
        // Deduct USDT
        final newUsdtAmount = usdtAsset.amount - Decimal.parse(totalCost.toString());
        updatedAssets[usdtIndex] = usdtAsset.copyWith(amount: newUsdtAmount);
        
        // Add Crypto
        if (targetAsset != null) {
          final newCryptoAmount = targetAsset.amount + Decimal.parse(cryptoAmount.toString());
          updatedAssets[targetIndex] = targetAsset.copyWith(amount: newCryptoAmount);
        } else {
          updatedAssets.add(AssetModel(
            coinId: coinId,
            symbol: symbol,
            amount: Decimal.parse(cryptoAmount.toString()),
          ));
        }
      } else if (type == TransactionType.sell) {
        if (targetAsset == null || targetAsset.amount.toDouble() < cryptoAmount) {
          throw Exception('Insufficient $symbol balance');
        }
        
        // Deduct Crypto
        final newCryptoAmount = targetAsset.amount - Decimal.parse(cryptoAmount.toString());
        updatedAssets[targetIndex] = targetAsset.copyWith(amount: newCryptoAmount);
        
        // Add USDT
        final double totalReturn = fiatValue - fee;
        if (usdtAsset != null) {
          final newUsdtAmount = usdtAsset.amount + Decimal.parse(totalReturn.toString());
          updatedAssets[usdtIndex] = usdtAsset.copyWith(amount: newUsdtAmount);
        } else {
          updatedAssets.add(AssetModel(
            coinId: 'tether',
            symbol: 'USDT',
            amount: Decimal.parse(totalReturn.toString()),
          ));
        }
      } else {
        throw Exception('Invalid trade type');
      }

      final walletJson = wallet.copyWith(assets: updatedAssets).toJson();
      walletJson['assets'] = updatedAssets.map((a) => a.toJson()).toList();
      
      transaction.set(walletRef, walletJson);
      
      final tx = TransactionModel(
        id: txRef.id,
        type: type,
        assetSymbol: symbol,
        amount: Decimal.parse(cryptoAmount.toString()),
        fiatValue: Decimal.parse(fiatValue.toString()),
        timestamp: DateTime.now(),
      );
      
      transaction.set(txRef, tx.toJson());
    });
  }
}
