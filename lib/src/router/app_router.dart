import 'package:flutter/material.dart';
import 'package:flutter_demo/src/router/base_arguments.dart';
import 'package:flutter_demo/src/router/routes.dart';

class AppRouter {
  static final _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static Widget generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    if (!routes.containsKey(routeSettings.name)) {
      throw UnimplementedError('${routeSettings.name} not implemented');
    }

    if (args is! BaseArguments?) {
      throw 'Argument must extend BaseArguments';
    }

    return routes[routeSettings.name]!.call(args);
  }

  static String? pushRestorable<T extends BaseArguments>(String routeName,
      {T? arguments}) {
    return _navigatorKey.currentState
        ?.restorablePushNamed(routeName, arguments: arguments);
  }

  static Future<T?> push<T extends BaseArguments>(String routeName,
      {T? arguments}) async {
    return await _navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  static void pop([dynamic result]) {
    _navigatorKey.currentState?.pop(result);
  }
}
