import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:wallet/features/profile/domain/models/app_currency.dart';

class Formatters {
  static String formatFiat(
    double usdValue, {
    AppCurrency? currency,
    double fxRate = 1.0,
  }) {
    final targetCurrency = currency ?? AppCurrency.usd;
    final convertedValue = usdValue * fxRate;

    final formatter = NumberFormat.currency(
      locale: 'en_US', // Keep consistent formatting style (e.g. 1,000.00)
      symbol: targetCurrency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(convertedValue);
  }

  static String formatCrypto(Decimal value) {
    // Uses up to 8 decimal places, removing trailing zeros
    final formatter = NumberFormat('#,##0.########');
    return formatter.format(value.toDouble());
  }

  static String formatCompactFiat(
    double usdValue, {
    AppCurrency? currency,
    double fxRate = 1.0,
  }) {
    final targetCurrency = currency ?? AppCurrency.usd;
    final convertedValue = usdValue * fxRate;
    
    final formatter = NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: targetCurrency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(convertedValue);
  }
}
