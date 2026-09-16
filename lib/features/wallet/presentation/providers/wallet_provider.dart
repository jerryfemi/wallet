import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';

part 'wallet_provider.g.dart';

@riverpod
WalletRepository walletRepository(Ref ref) {
  return WalletRepositoryImpl(FirebaseFirestore.instance);
}

@riverpod
Stream<WalletEntity?> walletStream(Ref ref) {
  // 1. Get the current authenticated user
  final user = ref.watch(authStateProvider).value;

  if (user == null) {
    // If they aren't logged in, they have no wallet!
    return Stream.value(null);
  }

  // 2. Get our repository
  final repository = ref.watch(walletRepositoryProvider);

  // 3. Start watching their wallet in Firestore
  return repository.watchWallet(user.uid);
}

@riverpod
Stream<List<TransactionEntity>> transactionsStream(Ref ref) {
  // 1. Get the current authenticated user
  final user = ref.watch(authStateProvider).value;

  if (user == null) {
    return Stream.value([]);
  }

  // 2. Get our repository
  final repository = ref.watch(walletRepositoryProvider);

  // 3. Start watching their transactions
  return repository.watchTransactions(user.uid);
}
