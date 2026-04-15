import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Datasource local para wallet/saldo
@lazySingleton
class WalletLocalDatasource {
  WalletLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _walletKey = 'wallet';
  static const double _initialBalance = 500000; // COP $500.000

  /// Obtiene el saldo actual
  Future<double> getBalance() async {
    final json = _prefs.getString(_walletKey);
    if (json == null) {
      // Primera vez: inicializar con saldo base
      await _prefs.setString(
        _walletKey,
        jsonEncode({'balance': _initialBalance}),
      );
      return _initialBalance;
    }

    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return (decoded['balance'] as num).toDouble();
  }

  /// Resta monto (para suscripcion)
  Future<void> deductAmount(double amount) async {
    final current = await getBalance();
    final newBalance = current - amount;
    await _prefs.setString(
      _walletKey,
      jsonEncode({'balance': newBalance}),
    );
  }

  /// Suma monto (para cancelacion)
  Future<void> addAmount(double amount) async {
    final current = await getBalance();
    final newBalance = current + amount;
    await _prefs.setString(
      _walletKey,
      jsonEncode({'balance': newBalance}),
    );
  }
}
