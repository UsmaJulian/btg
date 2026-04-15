import 'package:btg/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async => getIt.init();
