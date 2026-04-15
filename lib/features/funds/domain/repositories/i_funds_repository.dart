import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// Contrato para el repositorio de fondos
abstract class IFundsRepository {
  /// Obtiene la lista de todos los fondos disponibles
  Future<Result<List<Fund>>> getFunds();

  /// Suscribe al usuario a un fondo especifico
  /// [notificationMethod]: 'email' o 'sms'
  Future<Result<Transaction>> subscribeToFund({
    required String fundId,
    required String notificationMethod,
  });

  /// Cancela la suscripcion a un fondo especifico
  Future<Result<Transaction>> cancelFund({
    required String fundId,
  });
}
