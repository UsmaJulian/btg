import 'dart:convert';

import 'package:btg/features/transactions/data/models/transaction_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Datasource local para transacciones
@lazySingleton
class TransactionsLocalDatasource {
  TransactionsLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _transactionsKey = 'transactions';

  /// Guarda una nueva transaccion
  Future<void> saveTransaction(TransactionModel transaction) async {
    final existing = await getTransactions();
    existing.add(transaction);

    final sorted = existing..sort((a, b) => b.date.compareTo(a.date));

    await _prefs.setString(
      _transactionsKey,
      jsonEncode(sorted.map((e) => e.toJson()).toList()),
    );
  }

  /// Obtiene todas las transacciones ordenadas por fecha descendente
  Future<List<TransactionModel>> getTransactions() async {
    final json = _prefs.getString(_transactionsKey);
    if (json == null) return [];

    final decoded = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    return decoded.map(TransactionModel.fromJson).toList();
  }
}
