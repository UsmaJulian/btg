import 'package:btg/app/app.dart';
import 'package:btg/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
