import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/views/app_view.dart';

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _routerKey,
          routes: const[
            GoRoute(),
            
      ],
    ),
  ],
);
