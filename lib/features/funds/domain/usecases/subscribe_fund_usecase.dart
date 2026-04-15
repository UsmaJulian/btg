import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:injectable/injectable.dart';

/// {@template subscribe_fund_usecase}
/// Caso de uso: Suscribirse a un fondo.
/// {@endtemplate}
@injectable
class SubscribeFundUsecase {
  /// {@macro subscribe_fund_usecase}
  const SubscribeFundUsecase(this._repository);

  final IFundsRepository _repository;

  /// {@template subscribe_fund_call}
  /// Ejecuta la lógica de suscripción enviando el id del fondo y el método de notificación.
  /// {@endtemplate}
  Future<Result<Transaction>> call({
    required String fundId,
    required String notificationMethod,
  }) async {
    return _repository.subscribeToFund(
      fundId: fundId,
      notificationMethod: notificationMethod,
    );
  }
}
