import 'package:btg/features/transactions/domain/entities/transaction.dart';

/// {@template transaction_model}
/// Modelo de datos para la entidad [Transaction].
///
/// Extiende la entidad de dominio y proporciona métodos de serialización
/// para persistencia local.
/// {@endtemplate}
class TransactionModel extends Transaction {
  /// {@macro transaction_model}
  const TransactionModel({
    required super.id,
    required super.fundId,
    required super.fundName,
    required super.amount,
    required super.type,
    required super.date,
    super.notificationMethod,
  });

  /// {@template transaction_model_from_json}
  /// Crea una instancia del modelo a partir de un mapa JSON.
  /// {@endtemplate}
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

  /// {@template transaction_model_from_entity}
  /// Crea una instancia del modelo a partir de la entidad de dominio [Transaction].
  /// {@endtemplate}
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

  /// {@template transaction_model_to_json}
  /// Convierte el modelo a un mapa JSON para persistencia.
  /// {@endtemplate}
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
