import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/auth/presentation/views/forget_password_view.dart';
import 'auth_names.dart';
import '../logic/auth_cubit.dart';
import '../presentation/views/login_view.dart';

class AuthRouter {
  static List<GoRoute> get routes => [
    // Login View
    GoRoute(
      path: AuthRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (BuildContext context) => sl<AuthCubit>(),
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: AuthRoutes.forgetPassword,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const ForgetPasswordView(),
      ),
    ),
  ];
}
