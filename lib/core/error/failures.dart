/// {@template failures}
/// Representación sellada (sealed) de los errores del dominio.
///
/// Las subclases de [Failure] modelan escenarios de error específicos,
/// permitiendo que la capa de presentación reaccione de forma tipada
/// y segura sin el uso de excepciones tradicionales.
/// {@endtemplate}
sealed class Failure {
  /// {@macro failures}
  const Failure(this.message);

  /// Descripción legible del error para ser mostrada al usuario final.
  final String message;
}

/// {@template insufficient_balance_failure}
/// Error disparado cuando el saldo disponible es inferior al monto mínimo del fondo.
/// {@endtemplate}
final class InsufficientBalanceFailure extends Failure {
  /// {@macro insufficient_balance_failure}
  InsufficientBalanceFailure({
    required this.required,
    required this.available,
  }) : super(
         'Saldo insuficiente. El fondo requiere '
         '\$${required.toStringAsFixed(0)} y tu saldo disponible es '
         '\$${available.toStringAsFixed(0)}.',
       );

  /// Monto requerido por el fondo.
  final double required;

  /// Saldo actual en la billetera del usuario.
  final double available;
}

/// {@template already_subscribed_failure}
/// Error disparado cuando se intenta suscribir a un fondo que ya está activo.
/// {@endtemplate}
final class AlreadySubscribedFailure extends Failure {
  /// {@macro already_subscribed_failure}
  const AlreadySubscribedFailure(String fundName)
    : super('Ya estás suscrito al fondo $fundName.');
}

/// {@template not_subscribed_failure}
/// Error disparado cuando se intenta cancelar un fondo en el que no hay suscripción.
/// {@endtemplate}
final class NotSubscribedFailure extends Failure {
  /// {@macro not_subscribed_failure}
  const NotSubscribedFailure(String fundName)
    : super('No tienes una suscripción activa en $fundName.');
}

/// {@template cache_failure}
/// Error relacionado con fallos en la persistencia local de datos.
/// {@endtemplate}
final class CacheFailure extends Failure {
  /// {@macro cache_failure}
  const CacheFailure(super.message);
}

/// {@template unexpected_failure}
/// Error genérico para situaciones no controladas.
/// {@endtemplate}
final class UnexpectedFailure extends Failure {
  /// {@macro unexpected_failure}
  const UnexpectedFailure()
    : super('Ocurrió un error inesperado. Intenta de nuevo.');
}
