import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/Router/app_router.dart';
import 'core/theme/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'تطبيق الموارد البشرية',
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: AppThemeManager.lightTheme,
          darkTheme: AppThemeManager.darkTheme,
          themeMode: ThemeMode.light, // ثيم ثابت
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}
