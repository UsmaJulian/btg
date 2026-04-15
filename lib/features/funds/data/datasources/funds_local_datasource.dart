import 'dart:convert';

import 'package:btg/features/funds/data/models/fund_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Datasource local para fondos (SharedPreferences)
@lazySingleton
class FundsLocalDatasource {
  FundsLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _fundsKey = 'funds';
  static const String _subscriptionsKey = 'subscriptions';

  /// Datos mock de los 5 fondos requeridos
  List<Map<String, dynamic>> get _mockFunds => [
    {
      'id': '1',
      'name': 'FPV_BTG_RECAUDADORA',
      'minAmount': 75000,
      'category': 'fpv',
    },
    {
      'id': '2',
      'name': 'FPV_BTG_ECOPETROL',
      'minAmount': 125000,
      'category': 'fpv',
    },
    {
      'id': '3',
      'name': 'DEUDAPRIVADA',
      'minAmount': 50000,
      'category': 'fic',
    },
    {
      'id': '4',
      'name': 'FDO-ACCIONES',
      'minAmount': 250000,
      'category': 'fic',
    },
    {
      'id': '5',
      'name': 'FPV_BTG_DINAMICA',
      'minAmount': 100000,
      'category': 'fpv',
    },
  ];

  /// Obtiene todos los fondos con estado de suscripcion
  Future<List<FundModel>> getFunds() async {
    final fundsJson = _prefs.getString(_fundsKey);
    if (fundsJson == null) {
      // Primera vez: inicializar con mocks
      await _prefs.setString(_fundsKey, jsonEncode(_mockFunds));
      return _mockFunds.map(FundModel.fromJson).toList();
    }

    final decoded = (jsonDecode(fundsJson) as List)
        .cast<Map<String, dynamic>>();
    final subscriptions = await _getSubscriptions();

    return decoded.map((e) {
      final fund = FundModel.fromJson(e);
      return fund.copyWithModel(isSubscribed: subscriptions.contains(fund.id));
    }).toList();
  }

  /// Verifica si esta suscrito a un fondo
  Future<bool> isSubscribed(String fundId) async {
    final subscriptions = await _getSubscriptions();
    return subscriptions.contains(fundId);
  }

  /// Agrega una suscripcion
  Future<void> subscribe(String fundId) async {
    final subscriptions = await _getSubscriptions();
    subscriptions.add(fundId);
    await _prefs.setString(
      _subscriptionsKey,
      jsonEncode(subscriptions.toList()),
    );
  }

  /// Elimina una suscripcion
  Future<void> unsubscribe(String fundId) async {
    final subscriptions = await _getSubscriptions();
    subscriptions.remove(fundId);
    await _prefs.setString(
      _subscriptionsKey,
      jsonEncode(subscriptions.toList()),
    );
  }

  Future<Set<String>> _getSubscriptions() async {
    final json = _prefs.getString(_subscriptionsKey);
    if (json == null) return {};
    final decoded = (jsonDecode(json) as List).cast<String>();
    return decoded.toSet();
  }
}
