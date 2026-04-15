import 'package:btg/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// {@template pump_app_extension}
/// Extensión sobre [WidgetTester] para simplificar el inflado de widgets en pruebas.
///
/// Proporciona un entorno controlado que incluye configuración de localización
/// y un [MaterialApp] base, evitando la repetición de código de configuración
/// en cada archivo de prueba de UI.
/// {@endtemplate}
extension PumpApp on WidgetTester {
  /// {@template pump_app_method}
  /// Envuelve el [widget] dado en un [MaterialApp] con soporte para internacionalización.
  ///
  /// Utiliza las delegaciones de localización y locales soportados definidos
  /// en el proyecto para asegurar que los widgets que dependan de contexto
  /// de traducción funcionen correctamente durante los tests.
  /// {@endtemplate}
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
