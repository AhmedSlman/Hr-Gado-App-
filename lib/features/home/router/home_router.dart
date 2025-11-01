import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import '../logic/home_cubit.dart';
import '../presentation/views/home_view.dart';
import 'home_names.dart';

class HomeRouter {
  static List<GoRoute> get routes => [
    // Home Screen
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) {
        final cubit = sl<HomeCubit>()..getHomeScreen();
        return BlocProvider<HomeCubit>.value(
          value: cubit,
          child: const HomeView(),
        );
      },
    ),
  ];
}
