import 'dart:developer';

import 'package:flutter_demo/src/core/utils/local_storage.dart';
import 'package:flutter_demo/src/core/utils/service_locator.dart';
import 'package:flutter_demo/src/ui/views/login_view.dart';

class StartUpController {
  final _localStorage = ServiceLocator.locate<LocalStorage>();

  Future<void> initializeApp() async {}

  String _initRoute() {
    if (!isAuthenticated) {
      return LoginView.routeName;
    }

    return '/';
  }

  String getInitialRoute() {
    String route = _initRoute();

    log("Startup Route: $route");
    return route;
  }

  bool get isFirstLaunch {
    return _localStorage.retrieveBool(LSKey.isFirstLaunch) ?? true;
  }

  bool get isAuthenticated {
    return _localStorage.retrieve(LSKey.accessToken).isNotEmpty;
  }
}
