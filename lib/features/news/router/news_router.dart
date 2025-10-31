import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';

import '../logic/news_cubit.dart';
import '../presentation/views/add_news_view.dart';
import '../presentation/views/news_view.dart';
import 'news_names.dart';

class NewsRouter {
  static List<GoRoute> get routes => [
    // News Screen
    GoRoute(
      path: NewsRoutes.news,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<NewsCubit>()..loadItems(),
        child: const NewsView(),
      ),
    ),
    // Add News Screen
    GoRoute(
      path: NewsRoutes.addNews,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<NewsCubit>(),
        child: const AddNewsView(),
      ),
    ),
  ];
}
