import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/repositories/i_transactions_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template get_transactions_usecase}
/// Caso de uso: Obtener historial de transacciones.
/// {@endtemplate}
@injectable
class GetTransactionsUsecase {
  /// {@macro get_transactions_usecase}
  const GetTransactionsUsecase(this._repository);

  final ITransactionsRepository _repository;

  /// {@template get_transactions_call}
  /// Ejecuta la consulta al repositorio para recuperar todas las transacciones.
  /// {@endtemplate}
  Future<Result<List<Transaction>>> call() async {
    return _repository.getTransactions();
  }
}
