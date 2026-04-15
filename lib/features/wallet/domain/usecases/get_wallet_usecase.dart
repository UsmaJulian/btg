import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:btg/features/wallet/domain/repositories/i_wallet_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template get_wallet_usecase}
/// Caso de uso encargado de recuperar la información del saldo del usuario.
/// {@endtemplate}
@injectable
class GetWalletUsecase {
  /// {@macro get_wallet_usecase}
  const GetWalletUsecase(this._repository);

  final IWalletRepository _repository;

  /// {@template get_wallet_call}
  /// Ejecuta la lógica para obtener el estado actual de la [Wallet].
  /// {@endtemplate}
  Future<Result<Wallet>> call() async {
    return _repository.getWallet();
  }
}
