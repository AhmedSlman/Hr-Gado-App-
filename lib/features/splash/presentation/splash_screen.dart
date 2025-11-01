import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/features/auth/router/auth_names.dart';
import 'package:hr_app/features/bottom_navigation/router/main_page_names.dart';
import '../logic/splash_cubit.dart';
import '../logic/splash_states.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..checkAuthStatus(),
      child: BlocListener<SplashCubit, SplashStates>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            if (state.isLoggedIn) {
              context.go(MainPageNames.mainPage);
            } else {
              context.go(AuthRoutes.login);
            }
          }
        },
        child: BlocBuilder<SplashCubit, SplashStates>(
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppAssets.image(
                      ImagesAssets.gado,
                      height: 150.h,
                      width: 150.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 30.h),
                    if (state is SplashLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
