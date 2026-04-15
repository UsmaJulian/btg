import 'package:btg/features/funds/domain/entities/fund.dart' show Fund;
import 'package:equatable/equatable.dart';

/// {@template transaction_type}
/// Clasifica la naturaleza del movimiento financiero.
///
/// [subscription]: Apertura o inversión en un fondo.
/// [cancellation]: Retiro o cierre de participación en un fondo.
/// {@endtemplate}
enum TransactionType { subscription, cancellation }

/// {@template transaction}
/// Entidad que representa un registro histórico de una operación financiera.
///
/// Modela los movimientos de suscripción y cancelación, permitiendo la
/// trazabilidad de auditoría sobre los fondos del usuario.
/// {@endtemplate}
class Transaction extends Equatable {
  /// {@macro transaction}
  const Transaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.type,
    required this.date,
    this.notificationMethod,
  });

  /// Identificador único de la transacción.
  final String id;

  /// Referencia al [Fund.id] asociado al movimiento.
  final String fundId;

  /// Nombre del fondo al momento de la transacción para histórico.
  final String fundName;

  /// Cuantía económica de la operación.
  final double amount;

  /// Tipo de movimiento realizado (Suscripción/Cancelación).
  final TransactionType type;

  /// Canal utilizado para informar al usuario (ej. email, sms).
  final String? notificationMethod;

  /// Fecha y hora exacta en la que se procesó la operación.
  final DateTime date;

  @override
  List<Object?> get props => [
    id,
    fundId,
    fundName,
    amount,
    type,
    notificationMethod,
    date,
  ];
}
