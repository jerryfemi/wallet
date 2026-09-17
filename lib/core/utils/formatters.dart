import 'package:intl/intl.dart';

class Formatters {
  static String formatFiat(double value) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(value);
  }
}
