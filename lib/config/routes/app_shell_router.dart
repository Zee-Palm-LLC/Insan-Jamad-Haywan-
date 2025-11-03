import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShellRouter {
  static StatefulShellRoute get shellRoute => _shellRoute;

  static final StatefulShellRoute _shellRoute = StatefulShellRoute.indexedStack(
    builder:
        (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return const SizedBox();
        },
    branches: [StatefulShellBranch(routes: [])],
  );
}
