import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:injectable/injectable.dart';

/// {@template cancel_fund_usecase}
/// Caso de uso: Cancelar suscripcion a un fondo.
/// {@endtemplate}
@injectable
class CancelFundUsecase {
  /// {@macro cancel_fund_usecase}
  const CancelFundUsecase(this._repository);

  final IFundsRepository _repository;

  /// {@template cancel_fund_call}
  /// Ejecuta la lógica de cancelación a través del repositorio.
  /// {@endtemplate}
  Future<Result<Transaction>> call({
    required String fundId,
  }) async {
    return _repository.cancelFund(fundId: fundId);
  }
}
