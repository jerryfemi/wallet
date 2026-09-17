import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  /// Stream the user's wallet to keep UI updated in real-time
  Stream<WalletEntity?> watchWallet(String userId);

  /// Stream the user's transaction history
  Stream<List<TransactionEntity>> watchTransactions(String userId);

  /// Creates a default wallet for a new user (empty by default)
  Future<void> createInitialWallet(String userId);

  /// Simulates depositing USDT into the user's wallet
  Future<void> simulateDeposit(String userId, double amount);
}
