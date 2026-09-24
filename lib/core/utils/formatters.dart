import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

class Formatters {
  static String formatFiat(double value) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(value);
  }

  static String formatCrypto(Decimal value) {
    // Uses up to 8 decimal places, removing trailing zeros
    final formatter = NumberFormat('#,##0.########');
    return formatter.format(value.toDouble());
  }
}
