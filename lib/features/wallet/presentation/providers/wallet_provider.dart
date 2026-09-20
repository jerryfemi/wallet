import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/features/wallet/domain/entities/transaction_entity.dart';
import 'package:wallet/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet/features/auth/presentation/providers/auth_provider.dart';
import 'package:wallet/features/markets/presentation/providers/markets_provider.dart';
import 'package:decimal/decimal.dart';

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

class PortfolioAsset {
  final String coinId;
  final String symbol;
  final String name;
  final Decimal amount;
  final double fiatValue;
  final double changePercentage24h;
  final String imageUrl;

  PortfolioAsset({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.fiatValue,
    required this.changePercentage24h,
    required this.imageUrl,
  });
}

@riverpod
Future<List<PortfolioAsset>> portfolioAssets(Ref ref) async {
  final wallet = await ref.watch(walletStreamProvider.future);
  if (wallet == null) return [];

  final markets = await ref.watch(marketsProvider.future);
  final livePrices = ref.watch(livePricesProvider);

  final List<PortfolioAsset> assets = [];

  for (final asset in wallet.assets) {
    if (asset.coinId == 'tether') {
      assets.add(
        PortfolioAsset(
          coinId: asset.coinId,
          symbol: asset.symbol,
          name: 'Tether',
          amount: asset.amount,
          fiatValue: asset.amount.toDouble(),
          changePercentage24h: 0.0,
          imageUrl:
              'https://assets.coingecko.com/coins/images/325/large/Tether.png',
        ),
      );
      continue;
    }

    final marketCoin = markets.firstWhere(
      (c) => c.id == asset.coinId,
      orElse: () =>
          throw Exception('Coin not found in markets: ${asset.coinId}'),
    );

    final tickerKey = '${marketCoin.symbol.toUpperCase()}-USD';
    final livePrice = (livePrices[tickerKey]?.price ?? marketCoin.currentPrice).toDouble();
    
    final fiatValue = asset.amount.toDouble() * livePrice;

    assets.add(
      PortfolioAsset(
        coinId: asset.coinId,
        symbol: asset.symbol,
        name: marketCoin.name,
        amount: asset.amount,
        fiatValue: fiatValue,
        changePercentage24h: marketCoin.priceChangePercentage24h.toDouble(),
        imageUrl: marketCoin.imageUrl,
      ),
    );
  }

  // Sort by fiat value descending
  assets.sort((a, b) => b.fiatValue.compareTo(a.fiatValue));
  return assets;
}

@riverpod
Future<double> portfolioTotalValue(Ref ref) async {
  final assets = await ref.watch(portfolioAssetsProvider.future);
  return assets.fold<double>(0.0, (acc, asset) => acc + asset.fiatValue);
}

@riverpod
Future<double> portfolioTotalChange24h(Ref ref) async {
  final assets = await ref.watch(portfolioAssetsProvider.future);
  if (assets.isEmpty) return 0.0;

  double totalValue = 0;
  double weightedChangeSum = 0;

  for (final asset in assets) {
    totalValue += asset.fiatValue;
    weightedChangeSum += asset.fiatValue * asset.changePercentage24h;
  }

  if (totalValue == 0) return 0.0;
  return weightedChangeSum / totalValue;
}

@riverpod
Future<void> simulateDeposit(Ref ref, double amount) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return;
  final repository = ref.read(walletRepositoryProvider);
  await repository.simulateDeposit(user.uid, amount);
}
