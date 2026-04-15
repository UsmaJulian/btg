import 'package:btg/app/app.dart';
import 'package:btg/bootstrap.dart';
import 'package:btg/core/di/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await bootstrap(() => const App());
}
