import 'package:go_router/go_router.dart';
import 'categories_names.dart';
import '../presentation/views/categories_view.dart';

class CategoriesRouter {
  static List<GoRoute> get routes => [
    // Categories Screen
    GoRoute(
      path: CategoriesRoutes.categories,
      builder: (context, state) => const CategoriesView(),
    ),
  ];
}
