/// Sealed class que representa todos los errores posibles en el dominio.
/// Los use cases retornan estos tipos, nunca excepciones crudas.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

/// Saldo insuficiente para cumplir el monto mínimo del fondo.
final class InsufficientBalanceFailure extends Failure {
  InsufficientBalanceFailure({
    required this.required,
    required this.available,
  }) : super(
         'Saldo insuficiente. El fondo requiere '
         '\$${required.toStringAsFixed(0)} y tu saldo disponible es '
         '\$${available.toStringAsFixed(0)}.',
       );
  final double required;
  final double available;
}

/// Ya estás suscrito a este fondo.
final class AlreadySubscribedFailure extends Failure {
  const AlreadySubscribedFailure(String fundName)
    : super('Ya estás suscrito al fondo $fundName.');
}

/// No tienes suscripción activa en este fondo para cancelar.
final class NotSubscribedFailure extends Failure {
  const NotSubscribedFailure(String fundName)
    : super('No tienes una suscripción activa en $fundName.');
}

/// Error genérico de capa de datos.
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Error inesperado.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure()
    : super('Ocurrió un error inesperado. Intenta de nuevo.');
}
