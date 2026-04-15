import 'package:equatable/equatable.dart';

/// {@template wallet}
/// Entidad de dominio que representa el balance financiero del usuario.
///
/// Se utiliza para validar la capacidad económica antes de realizar
/// operaciones de inversión en la plataforma.
/// {@endtemplate}
class Wallet extends Equatable {
  /// {@macro wallet}
  const Wallet({required this.balance});

  /// Saldo económico disponible en la billetera.
  final double balance;

  @override
  List<Object?> get props => [balance];
}
