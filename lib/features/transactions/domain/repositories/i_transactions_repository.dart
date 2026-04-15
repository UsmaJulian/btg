import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// Contrato para el repositorio de transacciones
abstract class ITransactionsRepository {
  /// Obtiene el historial de transacciones ordenado por fecha descendente
  Future<Result<List<Transaction>>> getTransactions();

  /// Guarda una nueva transaccion (suscripcion o cancelacion)
  Future<Result<Transaction>> saveTransaction(Transaction transaction);
}
