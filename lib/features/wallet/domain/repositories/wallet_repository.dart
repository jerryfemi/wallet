import '../entities/transaction_entity.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  /// Stream the user's wallet to keep UI updated in real-time
  Stream<WalletEntity?> watchWallet(String userId);

  /// Stream the user's transaction history
  Stream<List<TransactionEntity>> watchTransactions(String userId);

  /// Creates a default wallet for a new user seeded with $10k
  Future<void> createInitialWallet(String userId);
}
