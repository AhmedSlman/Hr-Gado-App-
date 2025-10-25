import 'package:go_router/go_router.dart';
import 'news_names.dart';
import '../presentation/views/news_view.dart';

class NewsRouter {
  static List<GoRoute> get routes => [
    // News Screen
    GoRoute(
      path: NewsRoutes.news,
      builder: (context, state) => const NewsView(),
    ),
  ];
}
