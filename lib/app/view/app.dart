import 'package:btg/core/router/router.dart';
import 'package:btg/core/theme/app_theme.dart';
import 'package:btg/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;

/// {@template app}
/// El widget raíz de la aplicación.
///
/// Se encarga de configurar los componentes globales esenciales de Flutter,
/// incluyendo el sistema de enrutamiento, la tematización (theming) y
/// la internacionalización (l10n).
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

/// Estado de [App] que integra la configuración de navegación.
///
/// Utiliza [RouterMixin] para desacoplar la lógica de configuración del
/// [GoRouter] de la declaración del árbol de widgets.
class _AppState extends State<App> with RouterMixin {
  @override
  Widget build(BuildContext context) {
    /// Utiliza el constructor [.router] para delegar la gestión de la pila
    /// de navegación a una configuración externa de [routerConfig].
    return MaterialApp.router(
      /// Desactiva el banner de modo depuración para mantener la fidelidad
      /// visual durante el desarrollo de la UI.
      debugShowCheckedModeBanner: false,

      /// {@template app_theme_config}
      /// Define la identidad visual de la aplicación.
      ///
      /// Se utiliza [AppTheme.lightTheme] como base de diseño siguiendo
      /// los lineamientos del sistema de diseño del proyecto.
      /// {@endtemplate}
      theme: AppTheme.lightTheme,

      /// {@template app_l10n_config}
      /// Configuración de internacionalización.
      ///
      /// [localizationsDelegates] gestiona la carga de archivos de traducción.
      /// [supportedLocales] define los idiomas disponibles en la aplicación.
      /// {@endtemplate}
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /// Configuración del enrutador obtenida a través de [RouterMixin].
      routerConfig: router,
    );
  }
}
