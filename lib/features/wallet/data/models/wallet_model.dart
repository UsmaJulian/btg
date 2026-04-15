import 'package:btg/features/wallet/domain/entities/wallet.dart';

/// {@template wallet_model}
/// Modelo de datos para la entidad [Wallet].
///
/// Proporciona la lógica de serialización para convertir el saldo del usuario
/// desde y hacia formatos compatibles con la persistencia local.
/// {@endtemplate}
class WalletModel extends Wallet {
  /// {@macro wallet_model}
  const WalletModel({required super.balance});

  /// {@template wallet_model_from_json}
  /// Crea una instancia de [WalletModel] a partir de un mapa JSON.
  /// {@endtemplate}
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num).toDouble(),
    );
  }

  /// {@template wallet_model_to_json}
  /// Convierte el modelo a un mapa JSON para almacenamiento.
  /// {@endtemplate}
  Map<String, dynamic> toJson() {
    return {'balance': balance};
  }
}
