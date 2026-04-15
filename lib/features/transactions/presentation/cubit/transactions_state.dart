part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, loaded, error }

class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  final TransactionsStatus status;
  final List<Transaction> transactions;
  final String? errorMessage;

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

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial() : super(status: TransactionsStatus.initial);
}
