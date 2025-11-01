import 'package:go_router/go_router.dart';
import 'splash_names.dart';
import '../presentation/splash_screen.dart';

class SplashRouter {
  static List<GoRoute> get routes => [
    // Splash Screen
    GoRoute(
      path: SplashRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
  ];
}
