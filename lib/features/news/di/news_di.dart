import 'package:hr_app/core/network/api_consumer.dart';

import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/news_repository.dart';
import '../data/repository/news_repository_impl.dart';
import '../logic/news_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for News feature
class NewsDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // Repository
    sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(remoteDataSource: sl<NewsRemoteDataSource>()),
    );

    // Cubit
    sl.registerFactory<NewsCubit>(() => NewsCubit(sl<NewsRepository>()));
  }
}
