import 'package:equatable/equatable.dart';

/// {@template fund_category}
/// Define las categorías legales y operativas de los fondos de inversión.
///
///  [fpv]: Fondo de Pensiones Voluntarias.
///  [fic]: Fondo de Inversión Colectiva.
/// {@endtemplate}
enum FundCategory { fpv, fic }

/// {@template fund}
/// Entidad de dominio que representa un fondo de inversión disponible.
///
/// Contiene la información estructural del producto financiero, incluyendo
/// sus requisitos de entrada y el estado de vinculación del usuario actual.
///
/// See also:
///  [FundCategory], para los tipos de fondos soportados.
/// {@endtemplate}
class Fund extends Equatable {
  /// {@macro fund}
  const Fund({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
    this.isSubscribed = false,
  });

  /// Identificador único del fondo en el sistema.
  final String id;

  /// Nombre comercial del fondo.
  final String name;

  /// Monto mínimo requerido para la suscripción inicial.
  final double minAmount;

  /// Clasificación del fondo según [FundCategory].
  final FundCategory category;

  /// Indica si el usuario actual posee una suscripción activa en este fondo.
  final bool isSubscribed;

  /// {@template fund_copy_with}
  /// Crea una nueva instancia de [Fund] manteniendo los valores actuales
  /// a menos que se especifiquen nuevos parámetros.
  /// {@endtemplate}
  Fund copyWith({
    String? id,
    String? name,
    double? minAmount,
    FundCategory? category,
    bool? isSubscribed,
  }) {
    return Fund(
      id: id ?? this.id,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object?> get props => [id, name, minAmount, category, isSubscribed];
}
