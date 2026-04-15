import 'package:btg/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// {@template injection_instance}
/// Punto de acceso global para el Service Locator del proyecto.
/// {@endtemplate}
final GetIt getIt = GetIt.instance;

/// {@template configure_dependencies}
/// Inicializa el grafo de dependencias de la aplicación utilizando [injectable].
///
/// Llama al método generado `init()` para registrar automáticamente todos los
/// servicios, repositorios y bloques anotados con `@injectable`, `@lazySingleton` o `@module`.
/// Debe ser invocado antes de ejecutar `runApp`.
/// {@endtemplate}
@InjectableInit(
  preferRelativeImports: true,
)
Future<void> configureDependencies() async => getIt.init();
