import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template shared_preferences_module}
/// Módulo de configuración para dependencias externas que requieren inicialización asíncrona.
///
/// Este módulo permite integrar [SharedPreferences] dentro del grafo de inyección
/// de dependencias de [injectable], asegurando que la instancia esté lista
/// antes de que otros servicios la requieran.
/// {@endtemplate}
@module
abstract class SharedPreferencesModule {
  /// {@template shared_preferences_provider}
  /// Provee la instancia de [SharedPreferences].
  ///
  /// La anotación `@preResolve` indica a [get_it] que debe esperar a que
  /// el `Future` se complete durante la fase de configuración inicial de la aplicación.
  /// {@endtemplate}
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
