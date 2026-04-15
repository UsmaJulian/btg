import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// {@template i_transactions_repository}
/// Contrato para el repositorio de transacciones.
///
/// Define las operaciones de lectura y escritura para el historial
/// de operaciones financieras del usuario.
/// {@endtemplate}
abstract class ITransactionsRepository {
  /// {@template get_transactions_interface}
  /// Obtiene el historial de transacciones ordenado por fecha descendente.
  /// {@endtemplate}
  Future<Result<List<Transaction>>> getTransactions();

  /// {@template save_transaction_interface}
  /// Guarda una nueva transaccion (suscripcion o cancelacion).
  /// {@endtemplate}
  Future<Result<Transaction>> saveTransaction(Transaction transaction);
}
