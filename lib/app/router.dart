import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/views/app_view.dart';
import 'package:madenler_kasa_sistemi/views/anasayfa_view/anasayfa_view.dart';
import 'package:madenler_kasa_sistemi/views/kasa_view/kasa_view.dart';
import 'package:madenler_kasa_sistemi/views/profil_view/profil_view.dart';

final _routerKey = GlobalKey<NavigatorState>();

class AppRoute {
  AppRoute._();

  static const String anasayfa = '/';
  static const String kasa = '/kasa';
  static const String profil = '/profil';
}

final GoRouter router = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoute.anasayfa,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.anasayfa,
              builder: (context, state) => const AnasayfaView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.kasa,
              builder: (context, state) => const KasaView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.profil,
              builder: (context, state) => const ProfilView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
