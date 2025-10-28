import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_error_page.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/auth/router/auth_names.dart';
import 'package:hr_app/features/categories/router/categories_names.dart';
import 'package:hr_app/features/categories/router/categories_router.dart';
import 'package:hr_app/features/home/router/home_names.dart';
import 'package:hr_app/features/home/router/home_router.dart';
import 'package:hr_app/features/time_sheet/router/time_sheet_names.dart';
import 'package:hr_app/features/time_sheet/router/time_sheet_router.dart';
import '../../features/auth/router/auth_router.dart';
import '../../features/splash/router/splash_router.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = TimeSheetRoutes.timeSheet;

  static final GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // التحقق من التوكن في كل تنقل
      final isLoggedIn = UserHelper.isLoggedIn;
      final isAuthRoute = state.uri.path.startsWith('/auth');
      final isSplashRoute = state.uri.path.startsWith('/splash');

      if (isLoggedIn && isAuthRoute) {
        return HomeRoutes.home;
      }
      if (!isLoggedIn && !isAuthRoute && !isSplashRoute) {
        return AuthRoutes.login;
      }
      return null;
    },
    routes: [
      // Feature Routers
      ...SplashRouter.routes,
      ...AuthRouter.routes,
      ...HomeRouter.routes,
      ...CategoriesRouter.routes,
      ...TimeSheetRouter.routes,
    ],

    errorPageBuilder: (context, state) =>
        MaterialPage(key: state.pageKey, child: ErrorPage()),
  );

  static String _getInitialRoute() {
    UserHelper.initialize();

    if (UserHelper.isLoggedIn) {
      return TimeSheetRoutes.timeSheet;
    } else {
      return AuthRoutes.login;
    }
  }
}
