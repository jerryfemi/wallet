import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/coin_entity.dart';
import '../../data/sources/coingecko_api_service.dart';
import '../../data/repositories/market_repository.dart';
import '../../../../core/network/dio_client.dart';

part 'markets_provider.g.dart';

@riverpod
DioClient dioClient(Ref ref) {
  return DioClient();
}

@riverpod
CoinGeckoApiService coinGeckoApiService(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CoinGeckoApiService(dioClient);
}

@riverpod
MarketRepository marketRepository(Ref ref) {
  final apiService = ref.watch(coinGeckoApiServiceProvider);
  return MarketRepository(apiService);
}

@riverpod
class Markets extends _$Markets {
  @override
  Future<List<CoinEntity>> build() async {
    return _fetchMarkets();
  }

  Future<List<CoinEntity>> _fetchMarkets() async {
    final repository = ref.watch(marketRepositoryProvider);
    return await repository.getTopCoins();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMarkets());
  }
}
