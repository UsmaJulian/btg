import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/repositories/i_transactions_repository.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso: Obtener historial de transacciones
@injectable
class GetTransactionsUsecase {
  const GetTransactionsUsecase(this._repository);

  final ITransactionsRepository _repository;

  Future<Result<List<Transaction>>> call() async {
    return _repository.getTransactions();
  }
}
