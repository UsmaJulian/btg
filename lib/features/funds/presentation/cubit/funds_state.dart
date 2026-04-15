part of 'funds_cubit.dart';

sealed class FundsState extends Equatable {
  const FundsState();

  @override
  List<Object> get props => [];
}

final class FundsInitial extends FundsState {}
