import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/repositories/i_transactions_repository.dart';
import 'package:btg/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// {@template fund_repository_impl}
/// Implementacion del repositorio de fondos
/// {@endtemplate}
@LazySingleton(as: IFundsRepository)
class FundRepositoryImpl implements IFundsRepository {
  /// {@macro fund_repository_impl}
  FundRepositoryImpl(
    this._fundsDatasource,
    this._walletDatasource,
    this._transactionsRepository,
  );

  final FundsLocalDatasource _fundsDatasource;
  final WalletLocalDatasource _walletDatasource;
  final ITransactionsRepository _transactionsRepository;
  final _uuid = const Uuid();

  /// {@template get_funds_impl}
  /// Obtiene la lista de fondos disponibles procesando posibles errores de caché.
  /// {@endtemplate}
  @override
  Future<Result<List<Fund>>> getFunds() async {
    try {
      final funds = await _fundsDatasource.getFunds();
      return Success(funds);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  /// {@template subscribe_to_fund_impl}
  /// Ejecuta el flujo de suscripción a un fondo, validando el estado previo y el saldo.
  /// {@endtemplate}
  @override
  Future<Result<Transaction>> subscribeToFund({
    required String fundId,
    required String notificationMethod,
  }) async {
    try {
      // 1. Verificar si ya esta suscrito
      final isSubscribed = await _fundsDatasource.isSubscribed(fundId);
      if (isSubscribed) {
        final fund = (await _fundsDatasource.getFunds()).firstWhere(
          (f) => f.id == fundId,
        );
        return Error(AlreadySubscribedFailure(fund.name));
      }

      // 2. Obtener el fondo y verificar monto minimo
      final funds = await _fundsDatasource.getFunds();
      final fund = funds.firstWhere((f) => f.id == fundId);
      final balance = await _walletDatasource.getBalance();

      if (balance < fund.minAmount) {
        return Error(
          InsufficientBalanceFailure(
            required: fund.minAmount,
            available: balance,
          ),
        );
      }

      // 3. Realizar suscripcion
      await _fundsDatasource.subscribe(fundId);
      await _walletDatasource.deductAmount(fund.minAmount);

      // 4. Crear transaccion
      final transaction = Transaction(
        id: _uuid.v4(),
        fundId: fundId,
        fundName: fund.name,
        amount: fund.minAmount,
        type: TransactionType.subscription,
        notificationMethod: notificationMethod,
        date: DateTime.now(),
      );

      await _transactionsRepository.saveTransaction(transaction);

      return Success(transaction);
    } catch (e) {
      return const Error(UnexpectedFailure());
    }
  }

  /// {@template cancel_fund_impl}
  /// Ejecuta el flujo de cancelación de un fondo y gestiona el reembolso.
  /// {@endtemplate}
  @override
  Future<Result<Transaction>> cancelFund({
    required String fundId,
  }) async {
    try {
      // 1. Verificar si esta suscrito
      final isSubscribed = await _fundsDatasource.isSubscribed(fundId);
      if (!isSubscribed) {
        final funds = await _fundsDatasource.getFunds();
        final fund = funds.firstWhere((f) => f.id == fundId);
        return Error(NotSubscribedFailure(fund.name));
      }

      // 2. Obtener monto del fondo para reembolso
      final funds = await _fundsDatasource.getFunds();
      final fund = funds.firstWhere((f) => f.id == fundId);

      // 3. Realizar cancelacion
      await _fundsDatasource.unsubscribe(fundId);
      await _walletDatasource.addAmount(fund.minAmount);

      // 4. Crear transaccion de cancelacion
      final transaction = Transaction(
        id: _uuid.v4(),
        fundId: fundId,
        fundName: fund.name,
        amount: fund.minAmount,
        type: TransactionType.cancellation,
        date: DateTime.now(),
      );

      await _transactionsRepository.saveTransaction(transaction);

      return Success(transaction);
    } catch (e) {
      return const Error(UnexpectedFailure());
    }
  }
}
