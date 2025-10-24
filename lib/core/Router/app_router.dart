import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_error_page.dart';

import '../../features/auth/router/auth_router.dart';
import '../../features/splash/router/splash_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'router_names.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = AppRoutes.splash;

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    debugLogDiagnostics: true,
    routes: [
      // Feature Routers
      ...SplashRouter.routes,
      // ...AuthRouter.routes,
    ],

    // Error page
    errorPageBuilder: (context, state) =>
        MaterialPage(key: state.pageKey, child: ErrorPage()),
  );
}
