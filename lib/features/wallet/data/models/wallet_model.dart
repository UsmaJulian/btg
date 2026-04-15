import 'package:btg/features/wallet/domain/entities/wallet.dart';

/// Modelo de datos para Wallet
class WalletModel extends Wallet {
  const WalletModel({required super.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance};
  }
}
