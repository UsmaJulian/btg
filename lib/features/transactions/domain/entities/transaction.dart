import 'package:equatable/equatable.dart';

/// Entidad que representa una transaccion (suscripcion o cancelacion)
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.type,
    required this.date,
    this.notificationMethod,
  });

  final String id;
  final String fundId;
  final String fundName;
  final double amount;
  final TransactionType type;
  final String? notificationMethod;
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

enum TransactionType { subscription, cancellation }
