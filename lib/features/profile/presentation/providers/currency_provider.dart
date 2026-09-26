import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wallet/features/profile/data/currency_local_datasource.dart';
import 'package:wallet/features/profile/domain/models/app_currency.dart';

part 'currency_provider.g.dart';

@Riverpod(keepAlive: true)
class Currency extends _$Currency {
  final _dataSource = CurrencyLocalDataSource();

  @override
  AppCurrency build() {
    // Kick off async load from disk — defaults to USD immediately.
    _loadSaved();
    return AppCurrency.usd;
  }

  /// Reads the persisted currency code from SharedPreferences and updates
  /// state if a previously saved preference is found.
  Future<void> _loadSaved() async {
    final code = await _dataSource.getSavedCurrencyCode();
    if (code != null) {
      state = AppCurrency.fromCode(code);
    }
  }

  /// Selects a new preferred currency, updating the UI immediately and
  /// persisting the choice in the background.
  void select(AppCurrency currency) {
    state = currency;
    _dataSource.saveCurrencyCode(currency.code);
  }
}
