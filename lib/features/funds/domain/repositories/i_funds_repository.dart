import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// {@template i_funds_repository}
/// Contrato para el repositorio de fondos.
///
/// Define las operaciones necesarias para gestionar la consulta de fondos,
/// suscripciones y cancelaciones.
/// {@endtemplate}
abstract class IFundsRepository {
  /// {@template get_funds_interface}
  /// Obtiene la lista de todos los fondos disponibles.
  /// {@endtemplate}
  Future<Result<List<Fund>>> getFunds();

  /// {@template subscribe_to_fund_interface}
  /// Suscribe al usuario a un fondo especifico.
  /// [notificationMethod]: 'email' o 'sms'.
  /// {@endtemplate}
  Future<Result<Transaction>> subscribeToFund({
    required String fundId,
    required String notificationMethod,
  });

  /// {@template cancel_fund_interface}
  /// Cancela la suscripcion a un fondo especifico.
  /// {@endtemplate}
  Future<Result<Transaction>> cancelFund({
    required String fundId,
  });
}
