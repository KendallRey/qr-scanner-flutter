import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_scanner/app/layout/scaffold.dart';
import 'package:qr_scanner/features/home/presentation/home_screen.dart';
import 'package:qr_scanner/features/scanner/presentation/scanner_screen.dart';
import 'package:qr_scanner/features/settings/presentation/settings_screen.dart';

class AppRoutes {
  static const String id = 'id';
  static const String home = '/';
  static const String scanner = '/scanner';
  static const String settings = '/settings';

  static const String titleHome = 'Home';
  static const String titleScanner = 'Scanner';
  static const String titleSettings = 'Settings';

  static HashMap<String, int> indexes = HashMap<String, int>.from({
    AppRoutes.home: 0,
    AppRoutes.scanner: 1,
    AppRoutes.settings: 2,
  });

  static HashMap<String, String> titles = HashMap<String, String>.from({
    AppRoutes.home: AppRoutes.titleHome,
    AppRoutes.scanner: AppRoutes.titleScanner,
    AppRoutes.settings: AppRoutes.titleSettings,
  });
}

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(initialLocation: AppRoutes.home, routes: [
          ShellRoute(
              builder: (context, state, child) {
                final url = state.uri.toString();
                final String pageTitle = AppRoutes.titles[url] ?? 'App';
                return AppScaffold(
                  title: pageTitle,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  pageBuilder: (ctx, state) =>
                      AppRouter.customTransitionPage(HomeScreenWidget(), state),
                ),
                GoRoute(
                  path: AppRoutes.scanner,
                  pageBuilder: (ctx, state) => AppRouter.customTransitionPage(
                      ScannerScreenWidget(), state),
                ),
                GoRoute(
                  path: AppRoutes.settings,
                  pageBuilder: (ctx, state) => AppRouter.customTransitionPage(
                      SettingsScreenWidget(), state),
                ),
              ]),
        ]);

  static CustomTransitionPage customTransitionPage(
      Widget page, GoRouterState state) {
    return CustomTransitionPage(
        key: state.pageKey,
        child: page,
        transitionDuration: Durations.medium2,
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          // var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          // return FadeTransition(opacity: fadeAnimation, child: child);
          return SlideTransition(position: offsetAnimation, child: child);
        });
  }
}
