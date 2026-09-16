import 'package:clothes_control/presentation/settings/presentation/screens/settings_screen.dart';
import 'package:clothes_control/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clothes_control/presentation/category/presentation/screens/categories_detail_screen.dart';
import 'package:clothes_control/presentation/category/presentation/screens/categories_list_screen.dart';
import 'package:clothes_control/presentation/cloth/presentation/screens/clothes_detail_screen.dart';
import 'package:clothes_control/presentation/cloth/presentation/screens/clothes_list_screen.dart';
import 'package:clothes_control/presentation/root/presentation/widgets/root_layout.dart';
import 'package:clothes_control/presentation/status/presentation/screens/statuses_detail_screen.dart';
import 'package:clothes_control/presentation/status/presentation/screens/statuses_list_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _clothesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'clothes');
final GlobalKey<NavigatorState> _categoriesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'categories');
final GlobalKey<NavigatorState> _statusesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'statuses');
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'settings');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/clothes',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _clothesNavigatorKey,
            routes: [
              GoRoute(
                path: '/clothes',
                name: RouteNames.clothes,
                builder: (context, state) => ClothesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RouteNames.clothesDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return ClothesDetailScreen(id: int.tryParse(id));
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _categoriesNavigatorKey,
            routes: [
              GoRoute(
                path: '/categories',
                name: RouteNames.categories,
                builder: (context, state) => const CategoriesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RouteNames.categoriesDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return CategoriesDetailScreen(id: int.tryParse(id));
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _statusesNavigatorKey,
            routes: [
              GoRoute(
                path: '/statuses',
                name: RouteNames.statuses,
                builder: (context, state) => const StatusesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RouteNames.statusesDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return StatusesDetailScreen(id: int.tryParse(id));
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
