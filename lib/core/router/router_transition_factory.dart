import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// {@template router_transition_factory}
/// Fábrica centralizada para la creación de transiciones de página personalizadas.
///
/// Esta clase desacopla la lógica de las animaciones de la definición de las rutas,
/// permitiendo una experiencia de usuario consistente mediante el uso de
/// [CustomTransitionPage].
/// {@endtemplate}
class RouterTransitionFactory {
  /// {@template get_transition_page}
  /// Genera una [CustomTransitionPage] con una animación específica.
  ///
  ///  [context]: El contexto de construcción actual.
  ///  [state]: El estado de la ruta proporcionado por [GoRouter].
  ///  [child]: El widget (página) que se mostrará.
  ///  [type]: El identificador de la animación (ej. 'fade'). Actualmente,
  /// la implementación por defecto utiliza una transición de opacidad.
  ///
  /// See also:
  ///  [FadeTransition], la animación utilizada para la transición de entrada.
  /// {@endtemplate}
  static CustomTransitionPage<void> getTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required String type,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        /// Implementación de una transición de desvanecimiento (Fade).
        ///
        /// La [animation] controla el progreso de la opacidad del [child]
        /// durante la navegación entre rutas.
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
