import 'package:go_router/go_router.dart';

import '../presentation/views/home_view.dart';
import 'home_names.dart';

class HomeRouter {
  static List<GoRoute> get routes => [
    // Home Screen
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
  ];
}
