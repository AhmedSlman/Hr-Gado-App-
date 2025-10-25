import 'package:go_router/go_router.dart';
import 'home_names.dart';
import '../presentation/views/home_view.dart';

class HomeRouter {
  static List<GoRoute> get routes => [
    // Home Screen
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
  ];
}
