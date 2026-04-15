import 'package:equatable/equatable.dart';

/// Entidad que representa el saldo del usuario
class Wallet extends Equatable {
  const Wallet({required this.balance});

  final double balance;

  @override
  List<Object?> get props => [balance];
}
