import 'package:btg/app/view/app.dart';
import 'package:btg/core/router/router_transition_factory.dart';
import 'package:btg/core/router/routes.dart';
import 'package:btg/features/funds/presentation/pages/fund_detail_page.dart';
import 'package:btg/features/funds/presentation/pages/funds_page.dart';
import 'package:btg/features/transactions/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

mixin RouterMixin on State<App> {
  final router = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        name: Routes.funds,
        path: '/',
        builder: (context, state) => const FundsPage(),
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              child: const FundsPage(),
              state: state,
              type: 'size',
            ),
      ),
      GoRoute(
        name: Routes.fundDetail,
        path: '/funds/:id',
        builder: (context, state) => const FundDetailPage(),
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              child: const FundDetailPage(),
              state: state,
              type: 'size',
            ),
      ),
      GoRoute(
        name: Routes.transactions,
        path: '/transactions',
        builder: (context, state) => const TransactionsPage(),
        pageBuilder: (context, state) =>
            RouterTransitionFactory.getTransitionPage(
              context: context,
              child: const TransactionsPage(),
              state: state,
              type: 'size',
            ),
      ),
    ],
  );
}
