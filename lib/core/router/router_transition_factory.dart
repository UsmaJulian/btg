import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterTransitionFactory {
  static CustomTransitionPage<void> getTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required String type,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
