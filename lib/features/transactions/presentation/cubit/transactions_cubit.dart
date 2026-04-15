import 'package:bloc/bloc.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'transactions_state.dart';

/// {@template transactions_cubit}
/// Manejador de la lógica de negocio para el historial de transacciones.
///
/// Este [Cubit] gestiona la recuperación y el estado de la lista de movimientos
/// financieros del usuario, comunicándose con la capa de dominio a través
/// de [GetTransactionsUsecase].
/// {@endtemplate}
@injectable
class TransactionsCubit extends Cubit<TransactionsState> {
  /// {@macro transactions_cubit}
  TransactionsCubit({
    required GetTransactionsUsecase getTransactionsUsecase,
  }) : _getTransactionsUsecase = getTransactionsUsecase,
       super(const TransactionsState());

  final GetTransactionsUsecase _getTransactionsUsecase;

  /// {@template load_transactions}
  /// Solicita la carga del historial de transacciones.
  ///
  /// Actualiza el estado a [TransactionsStatus.loading] y, tras la resolución
  /// del caso de uso, emite los datos obtenidos o un mensaje de error.
  /// {@endtemplate}
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
