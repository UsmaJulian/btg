import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso: Suscribirse a un fondo
@injectable
class SubscribeFundUsecase {
  const SubscribeFundUsecase(this._repository);

  final IFundsRepository _repository;

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
