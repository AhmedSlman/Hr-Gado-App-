import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_error_page.dart';
import 'package:hr_app/features/auth/router/auth_names.dart';

import '../../features/auth/router/auth_router.dart';
import '../../features/splash/router/splash_router.dart';
import 'router_names.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = AuthRoutes.login;

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [
      // Feature Routers
      ...SplashRouter.routes,
      ...AuthRouter.routes,
    ],

    // Error page
    errorPageBuilder: (context, state) =>
        MaterialPage(key: state.pageKey, child: ErrorPage()),
  );
}
