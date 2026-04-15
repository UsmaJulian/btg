import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(TransactionsInitial());
}
