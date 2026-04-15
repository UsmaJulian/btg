import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

/// {@template app_bloc_observer}
/// Un [BlocObserver] personalizado que registra los cambios y errores en todos los Blocs.
///
/// Extiende la funcionalidad de [BlocObserver] para proporcionar visibilidad
/// en el ciclo de vida de los componentes de lógica de negocio, facilitando
/// el rastreo de estados y la depuración en tiempo de ejecución.
/// {@endtemplate}
class AppBlocObserver extends BlocObserver {
  /// {@macro app_bloc_observer}
  const AppBlocObserver();

  /// Llamado cada vez que ocurre un [change] en cualquier [bloc].
  /// Un [change] sucede cuando se emite un nuevo estado.
  ///

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  /// Llamado cada vez que se lanza un [error] en cualquier [Bloc] o [Cubit].
  ///
  /// Proporciona el [bloc] donde ocurrió el error, el objeto [error]
  /// y el [stackTrace] correspondiente para su análisis.
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// {@template bootstrap}
/// Función encargada de centralizar el arranque y la configuración global de la aplicación.
///
/// Esta función permite inyectar una capa de configuración que es común a todos
/// los sabores (flavors) del proyecto, como la gestión de errores del framework
/// y la observación global de estados.
/// {@endtemplate}
///
/// [builder]: Una función que devuelve un [Widget] (o un [Future] de un Widget)
/// que representa la raíz de la aplicación.
///
/// See also:
///  [AppBlocObserver], para la gestión de logs de estado.
///  [FlutterError.onError], para la captura de excepciones no controladas en el framework.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  /// Captura y registra errores de Flutter de manera global.
  ///
  /// Redirige las excepciones detectadas por el framework hacia el [log]
  /// del desarrollador para mantener trazabilidad incluso en errores de renderizado.
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  /// Asigna el observador global para todos los Blocs.
  ///
  /// Esto garantiza que cada cambio de estado y error en cualquier componente
  /// de la aplicación sea procesado por [AppBlocObserver].
  Bloc.observer = const AppBlocObserver();

  // Aquí se pueden añadir configuraciones adicionales que crucen todos los flavors.

  /// Ejecuta la aplicación instanciando el widget proporcionado por el builder.
  runApp(await builder());
}
