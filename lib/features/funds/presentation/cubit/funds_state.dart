part of 'funds_cubit.dart';

/// Representación de los posibles estados de la pantalla de fondos.
enum FundsStatus { initial, loading, loaded, error }

/// {@template funds_state}
/// Estado inmutable que contiene la información necesaria para renderizar
/// la gestión de fondos.
///
/// Utiliza [Equatable] para optimizar la reconstrucción de la UI comparando
/// las propiedades del estado.
/// {@endtemplate}
class FundsState extends Equatable {
  /// {@macro funds_state}
  const FundsState({
    this.status = FundsStatus.initial,
    this.funds = const [],
    this.errorMessage,
    this.balance = 500000,
  });

  /// Estado actual del flujo de datos.
  final FundsStatus status;

  /// Lista de fondos disponibles.
  final List<Fund> funds;

  /// Mensaje descriptivo en caso de error.
  final String? errorMessage;

  /// Saldo actual disponible en la billetera del usuario.
  final double balance;

  /// {@template copy_with_funds_state}
  /// Crea una copia del estado actual sustituyendo solo los valores proporcionados.
  ///
  ///  [clearError]: Si es true, fuerza el [errorMessage] a nulo.
  /// {@endtemplate}
  FundsState copyWith({
    FundsStatus? status,
    List<Fund>? funds,
    String? errorMessage,
    double? balance,
    bool clearError = false,
  }) {
    return FundsState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [status, funds, errorMessage, balance];
}

/// Estado inicial de la funcionalidad.
final class FundsInitial extends FundsState {
  const FundsInitial() : super(status: FundsStatus.initial);
}
