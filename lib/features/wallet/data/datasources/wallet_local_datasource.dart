import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template wallet_local_datasource}
/// Datasource local para wallet/saldo.
///
/// Gestiona la persistencia del balance del usuario utilizando [SharedPreferences].
/// {@endtemplate}
@lazySingleton
class WalletLocalDatasource {
  /// {@macro wallet_local_datasource}
  WalletLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _walletKey = 'wallet';
  static const double _initialBalance = 500000; // COP $500.000

  /// {@template get_balance}
  /// Obtiene el saldo actual del usuario. Si no existe, inicializa con [_initialBalance].
  /// {@endtemplate}
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

  /// {@template deduct_amount}
  /// Resta un monto específico del saldo actual (para procesos de suscripción).
  /// {@endtemplate}
  Future<void> deductAmount(double amount) async {
    final current = await getBalance();
    final newBalance = current - amount;
    await _prefs.setString(
      _walletKey,
      jsonEncode({'balance': newBalance}),
    );
  }

  /// {@template add_amount}
  /// Suma un monto específico al saldo actual (para procesos de cancelación/reembolso).
  /// {@endtemplate}
  Future<void> addAmount(double amount) async {
    final current = await getBalance();
    final newBalance = current + amount;
    await _prefs.setString(
      _walletKey,
      jsonEncode({'balance': newBalance}),
    );
  }
}
