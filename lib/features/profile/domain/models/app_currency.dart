/// Represents a fiat currency the user can choose as their display preference.
class AppCurrency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });

  /// All currencies we support for display.
  static const List<AppCurrency> supported = [
    usd,
    eur,
    gbp,
    ngn,
    jpy,
    cad,
    aud,
    chf,
  ];

  static const usd = AppCurrency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸');
  static const eur = AppCurrency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺');
  static const gbp = AppCurrency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧');
  static const ngn = AppCurrency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬');
  static const jpy = AppCurrency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵');
  static const cad = AppCurrency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flag: '🇨🇦');
  static const aud = AppCurrency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺');
  static const chf = AppCurrency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', flag: '🇨🇭');

  /// Look up a currency by its code, falling back to USD.
  static AppCurrency fromCode(String code) {
    return supported.firstWhere(
      (c) => c.code == code,
      orElse: () => usd,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCurrency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
