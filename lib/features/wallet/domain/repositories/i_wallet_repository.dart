import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';

/// {@template i_wallet_repository}
/// Contrato para el repositorio de gestión de saldo (Wallet).
///
/// Define las operaciones necesarias para consultar y modificar el balance
/// disponible del usuario dentro de la aplicación.
/// {@endtemplate}
abstract class IWalletRepository {
  /// {@template get_wallet_interface}
  /// Obtiene el saldo actual del usuario envuelto en un [Result].
  /// {@endtemplate}
  Future<Result<Wallet>> getWallet();

  /// {@template deduct_amount_interface}
  /// Resta un monto específico del saldo actual.
  /// Generalmente utilizado al confirmar una suscripción a un fondo.
  /// {@endtemplate}
  Future<Result<Wallet>> deductAmount(double amount);

  /// {@template add_amount_interface}
  /// Suma un monto específico al saldo actual.
  /// Generalmente utilizado al cancelar una suscripción a un fondo.
  /// {@endtemplate}
  Future<Result<Wallet>> addAmount(double amount);
}
