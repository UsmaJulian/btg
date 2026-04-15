import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:btg/features/transactions/data/models/transaction_model.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/repositories/i_transactions_repository.dart';
import 'package:injectable/injectable.dart';

/// Implementacion del repositorio de transacciones
@LazySingleton(as: ITransactionsRepository)
class TransactionsRepositoryImpl implements ITransactionsRepository {
  TransactionsRepositoryImpl(this._datasource);

  final TransactionsLocalDatasource _datasource;

  @override
  Future<Result<List<Transaction>>> getTransactions() async {
    try {
      final transactions = await _datasource.getTransactions();
      return Success(transactions);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Transaction>> saveTransaction(Transaction transaction) async {
    try {
      await _datasource.saveTransaction(
        TransactionModel.fromEntity(transaction),
      );
      return Success(transaction);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}
