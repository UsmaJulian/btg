import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:btg/features/wallet/domain/repositories/i_wallet_repository.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso: Obtener saldo actual
@injectable
class GetWalletUsecase {
  const GetWalletUsecase(this._repository);

  final IWalletRepository _repository;

  Future<Result<Wallet>> call() async {
    return _repository.getWallet();
  }
}
