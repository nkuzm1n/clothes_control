import 'package:clothes_control/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension AppRouterNavigation on BuildContext {
  int _getTabIndexForRoute(String routeName) {
    switch (routeName) {
      case RouteNames.clothes:
      case RouteNames.clothesDetail:
        return 0;
      case RouteNames.categories:
      case RouteNames.categoriesDetail:
        return 1;
      case RouteNames.statuses:
      case RouteNames.statusesDetail:
        return 2;
      case RouteNames.settings:
        return 3;
      default:
        return 0;
    }
  }

  Future<T?> pushNamedAppRoute<T extends Object?>(
    String name, {
    int? index,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    return await pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void goNamedAppRoute(
    String name, {
    int? index,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
