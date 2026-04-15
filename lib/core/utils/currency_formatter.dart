import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'COP $',
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);

  /// Ej: 500000 → "COP $500.000"
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return 'COP \$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'COP \$${(amount / 1000).toStringAsFixed(0)}K';
    }
    return format(amount);
  }
}
