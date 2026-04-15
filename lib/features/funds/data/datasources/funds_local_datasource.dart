import 'dart:convert';

import 'package:btg/features/funds/data/models/fund_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template funds_local_datasource}
/// Datasource local para fondos (SharedPreferences)
/// {@endtemplate}
@lazySingleton
class FundsLocalDatasource {
  /// {@macro funds_local_datasource}
  FundsLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const String _fundsKey = 'funds';
  static const String _subscriptionsKey = 'subscriptions';

  /// {@template mock_funds}
  /// Datos mock de los 5 fondos requeridos
  /// {@endtemplate}
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

  /// {@template get_funds}
  /// Obtiene la lista de fondos desde el almacenamiento local.
  /// {@endtemplate}
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

  /// {@template is_subscribed}
  /// Verifica si esta suscrito a un fondo
  /// {@endtemplate}
  Future<bool> isSubscribed(String fundId) async {
    final subscriptions = await _getSubscriptions();
    return subscriptions.contains(fundId);
  }

  /// {@template subscribe}
  /// Agrega una suscripcion
  /// {@endtemplate}
  Future<void> subscribe(String fundId) async {
    final subscriptions = await _getSubscriptions();
    subscriptions.add(fundId);
    await _prefs.setString(
      _subscriptionsKey,
      jsonEncode(subscriptions.toList()),
    );
  }

  /// {@template unsubscribe}
  /// Elimina una suscripcion
  /// {@endtemplate}
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
