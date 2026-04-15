import 'package:btg/app/view/app.dart';
import 'package:btg/core/di/injection.dart';
import 'package:btg/core/router/router_transition_factory.dart';
import 'package:btg/core/router/routes.dart';
import 'package:btg/features/funds/presentation/cubit/funds_cubit.dart';
import 'package:btg/features/funds/presentation/pages/fund_detail_page.dart';
import 'package:btg/features/funds/presentation/pages/funds_page.dart';
import 'package:btg/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:btg/features/transactions/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Llave global para acceder al estado del [Navigator].
///
/// Permite realizar operaciones de navegación fuera del contexto de los widgets
/// si es necesario y define el contenedor raíz para [GoRouter].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// {@template router_mixin}
/// Mixin encargado de la configuración y gestión de rutas de la aplicación.
///
/// Implementa [GoRouter] para manejar la navegación declarativa, permitiendo
/// definir transiciones personalizadas y la inyección de BLoCs a nivel de ruta.
/// {@endtemplate}
mixin RouterMixin on State<App> {
  /// Instancia configurada de [GoRouter].
  ///
  /// Define la estructura de navegación, incluyendo la ruta inicial y
  /// la configuración de las páginas con sus respectivos manejadores de estado.
  late final router = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      /// {@template route_funds}
      /// Ruta raíz que muestra el listado de fondos.
      /// Inyecta el [FundsCubit] y dispara la carga inicial de datos.
      /// {@endtemplate}
      GoRoute(
        name: Routes.funds,
        path: '/',
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              state: state,
              type: 'fade',
              child: BlocProvider(
                create: (context) => getIt<FundsCubit>()..loadFunds(),
                child: const FundsPage(),
              ),
            ),
      ),

      /// {@template route_fund_detail}
      /// Ruta de detalle para un fondo específico identificado por [id].
      /// {@endtemplate}
      GoRoute(
        name: Routes.fundDetail,
        path: '/funds/:id',
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              state: state,
              type: 'fade',
              child: const FundDetailPage(),
            ),
      ),

      /// {@template route_transactions}
      /// Ruta para visualizar el historial de transacciones.
      /// Inyecta el [TransactionsCubit] y sincroniza los datos al entrar.
      /// {@endtemplate}
      GoRoute(
        name: Routes.transactions,
        path: '/transactions',
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              state: state,
              type: 'fade',
              child: BlocProvider(
                create: (context) =>
                    getIt<TransactionsCubit>()..loadTransactions(),
                child: const TransactionsPage(),
              ),
            ),
      ),
    ],
  );
}
