import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/home/logic/home_cubit.dart';
import 'home_names.dart';
import '../presentation/views/home_view.dart';

class HomeRouter {
  static List<GoRoute> get routes => [
    // Home Screen
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<HomeCubit>()..getHomeScreen(),
        child: const HomeView(),
      ),
    ),
  ];
}
