import 'package:hr_app/core/network/api_consumer.dart';

import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/home_repository.dart';
import '../data/repository/home_repository_impl.dart';
import '../logic/home_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for Home feature
class HomeDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // sl.registerLazySingleton<HomeLocalDataSource>(
    //   () => HomeLocalDataSourceImpl(),
    // );

    // Repository
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDataSource>()),
    );

    // Cubit
    sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
  }
}
