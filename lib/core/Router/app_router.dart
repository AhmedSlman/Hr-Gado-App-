import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_error_page.dart';
import 'package:hr_app/features/account/router/account_router.dart';
import 'package:hr_app/features/bottom_navigation/router/main_page_router.dart';
import 'package:hr_app/features/cars/router/cars_router.dart';
import 'package:hr_app/features/categories/router/categories_router.dart';
import 'package:hr_app/features/home/router/home_router.dart';
import 'package:hr_app/features/meetings/router/meetings_router.dart';
import 'package:hr_app/features/news/router/news_router.dart';
import 'package:hr_app/features/notifications/router/notifications_router.dart';
import 'package:hr_app/features/rules/router/rules_router.dart';
import 'package:hr_app/features/salary/router/salary_router.dart';
import 'package:hr_app/features/salary_deduction/router/salary_deduction_router.dart';
import 'package:hr_app/features/time_sheet/router/time_sheet_router.dart';
import 'package:hr_app/features/vacation/router/vacation_router.dart';
import '../../features/auth/router/auth_router.dart';
import '../../features/splash/router/splash_names.dart';
import '../../features/splash/router/splash_router.dart';

/// GoRouter configuration
class AppRouter {
  static String initialRoute = SplashRoutes.splash;

  static final GoRouter router = GoRouter(
    initialLocation: SplashRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Feature Routers
      ...SplashRouter.routes,
      ...AuthRouter.routes,
      ...HomeRouter.routes,
      ...CategoriesRouter.routes,
      ...TimeSheetRouter.routes,
      ...VacationRouter.routes,
      ...SalaryRouter.routes,
      ...NewsRouter.routes,
      ...MeetingsRouter.routes,
      ...RulesRouter.routes,
      ...AccountRouter.routes,
      ...NotificationsRouter.routes,
      ...CarsRouter.routes,
      ...SalaryDeductionRouter.routes,
      ...MainPageRouter.routes,
    ],

    errorPageBuilder: (context, state) =>
        MaterialPage(key: state.pageKey, child: ErrorPage()),
  );
}
