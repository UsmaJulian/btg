import 'package:btg/app/app.dart';
import 'package:btg/bootstrap.dart';
import 'package:btg/core/di/injection.dart';
import 'package:flutter/material.dart';

/// {@template main_development}
/// Punto de entrada principal para el entorno de desarrollo del proyecto.
///
/// Este archivo es el encargado de orquestar la secuencia de inicialización
/// de servicios globales, inyección de dependencias y el arranque del
/// framework antes de la construcción de la interfaz de usuario.
/// {@endtemplate}

/// Inicializa la ejecución de la aplicación en modo desarrollo.
///
/// Al utilizarse este punto de entrada, se asume que las configuraciones
/// de [configureDependencies] se resolverán bajo el contexto de desarrollo
/// (ej. APIs de pruebas, logging detallado).
///
/// See also:
///  [bootstrap], la función encargada de envolver la ejecución de la app con observadores globales.
///  [configureDependencies], donde se registra el grafo de objetos del proyecto.
Future<void> main() async {
  /// Asegura la correcta vinculación de los widgets de Flutter con el motor (engine).
  ///
  /// Debe llamarse antes de cualquier interacción con servicios nativos o
  /// operaciones asíncronas durante el arranque.
  WidgetsFlutterBinding.ensureInitialized();

  /// {@template dependency_injection}
  /// Configura el grafo de dependencias del sistema.
  ///
  /// Utiliza `get_it` e `injectable` para instanciar repositorios,
  /// servicios de dominio y casos de uso necesarios para la arquitectura.
  /// {@endtemplate}
  await configureDependencies();

  /// Inicia el proceso de arranque (bootstraping) de la aplicación.
  ///
  /// Recibe un [builder] que instancia el widget raíz [App].
  ///
  /// El uso de `const App()` asegura que el widget raíz se mantenga
  /// en memoria de forma eficiente, evitando reconstrucciones innecesarias
  /// desde el nivel superior del árbol.
  await bootstrap(() => const App());
}
