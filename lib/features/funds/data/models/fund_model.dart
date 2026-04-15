import 'package:btg/features/funds/domain/entities/fund.dart';

/// {@template fund_model}
/// Modelo de datos para la entidad [Fund] que incluye lógica de serialización.
///
/// Esta clase extiende la entidad de dominio para permitir la conversión
/// entre objetos Dart y mapas JSON, facilitando la persistencia local.
/// {@endtemplate}
class FundModel extends Fund {
  /// {@macro fund_model}
  const FundModel({
    required super.id,
    required super.name,
    required super.minAmount,
    required super.category,
    super.isSubscribed,
  });

  /// {@template fund_model_from_json}
  /// Crea una instancia de [FundModel] a partir de un mapa JSON.
  ///
  /// Mapea dinámicamente el campo `category` utilizando el enum [FundCategory].
  /// {@endtemplate}
  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'] as String,
      name: json['name'] as String,
      minAmount: (json['minAmount'] as num).toDouble(),
      category: FundCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => FundCategory.fpv,
      ),
      isSubscribed: json['isSubscribed'] as bool? ?? false,
    );
  }

  /// {@template fund_model_to_json}
  /// Convierte la instancia actual en un mapa compatible con JSON.
  /// {@endtemplate}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minAmount': minAmount,
      'category': category.name,
      'isSubscribed': isSubscribed,
    };
  }

  /// {@template fund_model_copy_with}
  /// Crea una copia del modelo permitiendo la modificación de propiedades específicas.
  /// {@endtemplate}
  FundModel copyWithModel({
    String? id,
    String? name,
    double? minAmount,
    FundCategory? category,
    bool? isSubscribed,
  }) {
    return FundModel(
      id: id ?? this.id,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}
