import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/coin_entity.dart';
import '../../data/sources/coingecko_api_service.dart';
import '../../data/repositories/market_repository.dart';
import '../../../../core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final coinGeckoApiServiceProvider = Provider<CoinGeckoApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CoinGeckoApiService(dioClient);
});

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  final apiService = ref.watch(coinGeckoApiServiceProvider);
  return MarketRepository(apiService);
});

final marketsProvider = AsyncNotifierProvider<MarketsNotifier, List<CoinEntity>>(
  MarketsNotifier.new,
);

class MarketsNotifier extends AsyncNotifier<List<CoinEntity>> {
  late final MarketRepository _repository;

  @override
  Future<List<CoinEntity>> build() async {
    _repository = ref.watch(marketRepositoryProvider);
    return _fetchMarkets();
  }

  Future<List<CoinEntity>> _fetchMarkets() async {
    return await _repository.getTopCoins();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMarkets());
  }
}
