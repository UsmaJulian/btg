import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'funds_state.dart';

class FundsCubit extends Cubit<FundsState> {
  FundsCubit() : super(FundsInitial());
}
