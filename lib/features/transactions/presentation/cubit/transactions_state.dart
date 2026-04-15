part of 'transactions_cubit.dart';

/// Define los estados posibles para el flujo de transacciones.
enum TransactionsStatus { initial, loading, loaded, error }

/// {@template transactions_state}
/// Estado inmutable que representa la información de la pantalla de transacciones.
///
/// Mantiene la trazabilidad del proceso de carga y almacena la lista de
/// [Transaction] recuperadas.
/// {@endtemplate}
class TransactionsState extends Equatable {
  /// {@macro transactions_state}
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  /// Estado actual del proceso de obtención de datos.
  final TransactionsStatus status;

  /// Lista de movimientos financieros cargados.
  final List<Transaction> transactions;

  /// Mensaje de error en caso de fallo en la carga.
  final String? errorMessage;

  /// {@template copy_with_transactions_state}
  /// Crea una copia de [TransactionsState] modificando solo los campos indicados.
  ///
  ///  [clearError]: Si se establece en true, el [errorMessage] se reinicia a nulo.
  /// {@endtemplate}
  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}

/// Estado inicial para el [TransactionsCubit].
final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial() : super(status: TransactionsStatus.initial);
}
