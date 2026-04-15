import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso: Obtener lista de fondos disponibles
@injectable
class GetFundsUsecase {
  const GetFundsUsecase(this._repository);

  final IFundsRepository _repository;

  Future<Result<List<Fund>>> call() async {
    return _repository.getFunds();
  }
}
