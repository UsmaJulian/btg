import 'package:btg/features/funds/domain/entities/fund.dart';

class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.minAmount,
    required super.category,
    super.isSubscribed,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minAmount': minAmount,
      'category': category.name,
      'isSubscribed': isSubscribed,
    };
  }

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
