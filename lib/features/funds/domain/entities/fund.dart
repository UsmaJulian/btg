import 'package:equatable/equatable.dart';

/// Entidad del fondo de inversión
class Fund extends Equatable {
  const Fund({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
    this.isSubscribed = false,
  });
  final String id;
  final String name;
  final double minAmount;
  final FundCategory category;
  final bool isSubscribed;

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

enum FundCategory { fpv, fic }
