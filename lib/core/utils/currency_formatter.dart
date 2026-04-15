import 'package:intl/intl.dart';

/// {@template currency_formatter}
/// Utilidad estática para el formateo de valores monetarios.
///
/// Proporciona métodos consistentes para presentar cifras financieras bajo
/// el estándar local (COP) y formatos compactos para optimización de espacio en UI.
/// {@endtemplate}
class CurrencyFormatter {
  /// Constructor privado para evitar la instanciación de la clase de utilidad.
  CurrencyFormatter._();

  /// Formateador base configurado para pesos colombianos (es_CO).
  static final _formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'COP $',
    decimalDigits: 0,
  );

  /// {@template format_currency}
  /// Convierte un valor numérico a una cadena formateada con símbolo y separadores.
  ///
  /// Ejemplo: `500000` -> `"COP $500.000"`
  /// {@endtemplate}
  static String format(double amount) => _formatter.format(amount);

  /// {@template format_compact_currency}
  /// Formatea valores grandes de forma abreviada (M para millones, K para miles).
  ///
  /// Útil para etiquetas de texto con espacio limitado.
  ///
  /// Ejemplo: `1000000` -> `"COP $1.0M"`
  /// {@endtemplate}
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
