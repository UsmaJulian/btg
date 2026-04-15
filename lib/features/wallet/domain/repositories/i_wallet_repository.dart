import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';

/// Contrato para el repositorio de wallet/saldo
abstract class IWalletRepository {
  /// Obtiene el saldo actual del usuario
  Future<Result<Wallet>> getWallet();

  /// Actualiza el saldo (para suscripcion - resta)
  Future<Result<Wallet>> deductAmount(double amount);

  /// Actualiza el saldo (para cancelacion - suma)
  Future<Result<Wallet>> addAmount(double amount);
}
