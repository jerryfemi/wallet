import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet/core/services/fx_rates_service.dart';
import 'package:wallet/features/profile/presentation/providers/currency_provider.dart';
import 'package:wallet/core/utils/formatters.dart';

part 'exchange_rates_provider.g.dart';

@Riverpod(keepAlive: true)
FxRatesService fxRatesService(Ref ref) {
  return FxRatesService();
}

@Riverpod(keepAlive: true)
class ExchangeRates extends _$ExchangeRates {
  @override
  Future<Map<String, double>> build() async {
    final service = ref.watch(fxRatesServiceProvider);
    return service.getRates();
  }

  Future<void> refreshRates() async {
    state = const AsyncValue.loading();
    final service = ref.read(fxRatesServiceProvider);
    try {
      final rates = await service.getRates();
      state = AsyncValue.data(rates);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
String Function(double) fiatFormatter(Ref ref) {
  final currency = ref.watch(currencyProvider);
  final rates = ref.watch(exchangeRatesProvider).value ?? {};
  final fxRate = rates[currency.code] ?? 1.0;

  return (double usdValue) {
    return Formatters.formatFiat(usdValue, currency: currency, fxRate: fxRate);
  };
}

