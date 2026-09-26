import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's preferred currency code to disk via [SharedPreferences].
class CurrencyLocalDataSource {
  static const _currencyKey = 'preferred_currency_code';

  /// Returns the previously saved currency code, or `null` if none was saved.
  Future<String?> getSavedCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  /// Persists the given [code] (e.g. 'EUR') to disk.
  Future<void> saveCurrencyCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, code);
  }
}
