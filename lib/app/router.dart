import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/app/go_router_refresh.dart';
import 'package:madenler_kasa_sistemi/views/app_view.dart';
import 'package:madenler_kasa_sistemi/views/anasayfa_view/anasayfa_view.dart';
import 'package:madenler_kasa_sistemi/views/giris_view/giris_view.dart';
import 'package:madenler_kasa_sistemi/views/kasa_view/kasa_view.dart';
import 'package:madenler_kasa_sistemi/views/kayit_view/kayit_view.dart';
import 'package:madenler_kasa_sistemi/views/profil_view/profil_view.dart';

final _routerKey = GlobalKey<NavigatorState>();

final _authRefresh = GoRouterRefreshStream(
  FirebaseAuth.instance.authStateChanges(),
);

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
  initialLocation: AppRoute.giris,
  refreshListenable: _authRefresh,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final path = state.uri.path;
    final onAuthPage = path == AppRoute.giris || path == AppRoute.kayit;

    if (user == null) {
      if (onAuthPage) return null;
      return AppRoute.giris;
    }
    if (onAuthPage) return AppRoute.anasayfa;
    return null;
  },
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
