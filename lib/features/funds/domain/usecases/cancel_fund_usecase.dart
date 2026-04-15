import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso: Cancelar suscripcion a un fondo
@injectable
class CancelFundUsecase {
  const CancelFundUsecase(this._repository);

  final IFundsRepository _repository;

  Future<Result<Transaction>> call({
    required String fundId,
  }) async {
    return _repository.cancelFund(fundId: fundId);
  }
}
