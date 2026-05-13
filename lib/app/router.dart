import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/views/app_view.dart';
import 'package:madenler_kasa_sistemi/views/anasayfa_view/anasayfa_view.dart';
import 'package:madenler_kasa_sistemi/views/giris_view/giris_view.dart';
import 'package:madenler_kasa_sistemi/views/kasa_view/kasa_view.dart';
import 'package:madenler_kasa_sistemi/views/kayit_view/kayit_view.dart';
import 'package:madenler_kasa_sistemi/views/profil_view/profil_view.dart';

final _routerKey = GlobalKey<NavigatorState>();

class AppRoute {
  AppRoute._();

  static const String anasayfa = '/';
  static const String kasa = '/kasa';
  static const String profil = '/profil';
  static const String giris = '/giris';
  static const String kayit = '/kayit';
}

final GoRouter router = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoute.anasayfa,
  routes: [
    GoRoute(
      path: AppRoute.giris,
      builder: (context, state) => const GirisView(),
    ),
    GoRoute(
      path: AppRoute.kayit,
      builder: (context, state) => const KayitView(),
    ),
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
