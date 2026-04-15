import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:btg/features/transactions/data/models/transaction_model.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/repositories/i_transactions_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template transactions_repository_impl}
/// Implementacion del repositorio de transacciones.
///
/// Actúa como puente entre el dominio y el datasource local para el historial.
/// {@endtemplate}
@LazySingleton(as: ITransactionsRepository)
class TransactionsRepositoryImpl implements ITransactionsRepository {
  /// {@macro transactions_repository_impl}
  TransactionsRepositoryImpl(this._datasource);

  final TransactionsLocalDatasource _datasource;

  /// {@template get_transactions_impl}
  /// Recupera el historial completo de transacciones.
  /// {@endtemplate}
  @override
  Future<Result<List<Transaction>>> getTransactions() async {
    try {
      final transactions = await _datasource.getTransactions();
      return Success(transactions);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  /// {@template save_transaction_impl}
  /// Convierte la entidad a modelo y persiste la transacción en el almacenamiento local.
  /// {@endtemplate}
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
