import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/bottom_navigation/presentation/main_page.dart';
import 'package:hr_app/features/home/logic/home_cubit.dart';
import 'main_page_names.dart';


class MainPageRouter {

   static List<GoRoute> get routes => [
    // Categories Screen
    GoRoute(
      path: MainPageNames.mainPage,
      builder: (context, state) =>BlocProvider(
        create: (context) => sl<HomeCubit>()..getHomeScreen(),
        child: const MainPage(),
      )
    ),
  ];
}