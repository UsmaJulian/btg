import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:btg/features/wallet/domain/repositories/i_wallet_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template wallet_repository_impl}
/// Implementación del repositorio de wallet utilizando [WalletLocalDatasource].
///
/// Gestiona la persistencia del saldo disponible para realizar transacciones
/// de fondos de inversión.
/// {@endtemplate}
@LazySingleton(as: IWalletRepository)
class WalletRepositoryImpl implements IWalletRepository {
  /// {@macro wallet_repository_impl}
  WalletRepositoryImpl(this._datasource);

  final WalletLocalDatasource _datasource;

  @override
  Future<Result<Wallet>> getWallet() async {
    try {
      final balance = await _datasource.getBalance();
      return Success(Wallet(balance: balance));
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Wallet>> deductAmount(double amount) async {
    try {
      await _datasource.deductAmount(amount);
      final newBalance = await _datasource.getBalance();
      return Success(Wallet(balance: newBalance));
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Wallet>> addAmount(double amount) async {
    try {
      await _datasource.addAmount(amount);
      final newBalance = await _datasource.getBalance();
      return Success(Wallet(balance: newBalance));
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}
