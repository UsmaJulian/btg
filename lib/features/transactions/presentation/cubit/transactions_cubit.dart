import 'package:bloc/bloc.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'transactions_state.dart';

@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({
    required GetTransactionsUsecase getTransactionsUsecase,
  }) : _getTransactionsUsecase = getTransactionsUsecase,
       super(const TransactionsState());

  final GetTransactionsUsecase _getTransactionsUsecase;

  Future<void> loadTransactions() async {
    emit(state.copyWith(status: TransactionsStatus.loading, clearError: true));

    final result = await _getTransactionsUsecase();

    if (result is Success<List<Transaction>>) {
      emit(
        state.copyWith(
          status: TransactionsStatus.loaded,
          transactions: result.data,
        ),
      );
    } else if (result is Error) {
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          errorMessage: (result as Error).failure.message,
        ),
      );
    }
  }
}
