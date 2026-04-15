import 'dart:convert';

import 'package:btg/features/transactions/data/models/transaction_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template transactions_local_datasource}
/// Datasource local para transacciones.
///
/// Almacena y recupera el historial de operaciones de suscripción y cancelación.
/// {@endtemplate}
@lazySingleton
class TransactionsLocalDatasource {
  /// {@macro transactions_local_datasource}
  TransactionsLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _transactionsKey = 'transactions';

  /// {@template save_transaction_local}
  /// Agrega una nueva transacción a la lista existente y la guarda ordenada por fecha.
  /// {@endtemplate}
  Future<void> saveTransaction(TransactionModel transaction) async {
    final existing = await getTransactions();
    existing.add(transaction);

    final sorted = existing..sort((a, b) => b.date.compareTo(a.date));

    await _prefs.setString(
      _transactionsKey,
      jsonEncode(sorted.map((e) => e.toJson()).toList()),
    );
  }

  /// {@template get_transactions_local}
  /// Obtiene todas las transacciones almacenadas decodificándolas desde JSON.
  /// {@endtemplate}
  Future<List<TransactionModel>> getTransactions() async {
    final json = _prefs.getString(_transactionsKey);
    if (json == null) return [];

    final decoded = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    return decoded.map(TransactionModel.fromJson).toList();
  }
}
