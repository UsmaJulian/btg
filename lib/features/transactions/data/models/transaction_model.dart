import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// Modelo de datos para Transaction
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.amount,
    required super.type,
    super.notificationMethod,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      fundId: json['fundId'] as String,
      fundName: json['fundName'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.subscription,
      ),
      notificationMethod: json['notificationMethod'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }

  factory TransactionModel.fromEntity(Transaction t) {
    return TransactionModel(
      id: t.id,
      fundId: t.fundId,
      fundName: t.fundName,
      amount: t.amount,
      type: t.type,
      notificationMethod: t.notificationMethod,
      date: t.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fundId': fundId,
      'fundName': fundName,
      'amount': amount,
      'type': type.name,
      'notificationMethod': notificationMethod,
      'date': date.toIso8601String(),
    };
  }
}
