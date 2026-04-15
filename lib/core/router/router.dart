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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

mixin RouterMixin on State<App> {
  late final router = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
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
