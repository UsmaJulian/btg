import 'package:btg/core/error/failures.dart';

/// {@template result}
/// Clase base sellada para implementar el patrón Result en la capa de dominio.
///
/// Proporciona un mecanismo robusto para el manejo de flujos lógicos,
/// obligando al manejo explícito de éxitos y errores sin depender del
/// lanzamiento de excepciones.
/// {@endtemplate}
sealed class Result<T> {
  /// {@macro result}
  const Result();
}

/// {@template success_result}
/// Representa una operación finalizada con éxito que contiene datos de tipo [T].
/// {@endtemplate}
final class Success<T> extends Result<T> {
  /// {@macro success_result}
  const Success(this.data);

  /// Carga útil (payload) del resultado exitoso.
  final T data;
}

/// {@template error_result}
/// Representa una falla en la ejecución de una operación.
/// {@endtemplate}
final class Error<T> extends Result<T> {
  /// {@macro error_result}
  const Error(this.failure);

  /// Objeto de falla que contiene el mensaje y código de error técnico.
  final Failure failure;
}
