import 'package:btg/core/error/failures.dart' show Failure;
import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/domain/repositories/i_funds_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template get_funds_usecase}
/// Caso de uso encargado de recuperar la lista de fondos disponibles.
///
/// Este componente actúa como orquestador de la lógica de dominio,
/// abstrayendo a la capa de presentación de la procedencia de los datos
/// a través de la interfaz [IFundsRepository].
/// {@endtemplate}
@injectable
class GetFundsUsecase {
  /// {@macro get_funds_usecase}
  const GetFundsUsecase(this._repository);

  /// Abstracción del repositorio de fondos.
  final IFundsRepository _repository;

  /// {@template get_funds_usecase_call}
  /// Ejecuta la lógica para obtener los fondos.
  ///
  /// Retorna un [Result] que contiene una lista de [Fund] en caso de éxito,
  /// o un [Failure] en caso de error.
  /// {@endtemplate}
  Future<Result<List<Fund>>> call() async {
    return _repository.getFunds();
  }
}
