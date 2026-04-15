part of 'funds_cubit.dart';

enum FundsStatus { initial, loading, loaded, error }

class FundsState extends Equatable {
  const FundsState({
    this.status = FundsStatus.initial,
    this.funds = const [],
    this.errorMessage,
    this.balance = 500000,
  });

  final FundsStatus status;
  final List<Fund> funds;
  final String? errorMessage;
  final double balance;

  FundsState copyWith({
    FundsStatus? status,
    List<Fund>? funds,
    String? errorMessage,
    double? balance,
    bool clearError = false,
  }) {
    return FundsState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [status, funds, errorMessage, balance];
}

final class FundsInitial extends FundsState {
  const FundsInitial() : super(status: FundsStatus.initial);
}
