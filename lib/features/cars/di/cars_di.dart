import 'package:hr_app/core/network/api_consumer.dart';

import '../../../../core/locator/service_locator.dart';
import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/cars_repository.dart';
import '../data/repository/cars_repository_impl.dart';
import '../logic/cars_cubit.dart';

/// Dependency injection setup for Cars feature
class CarsDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<CarsRemoteDataSource>(
      () => CarsRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<CarsLocalDataSource>(
      () => CarsLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<CarsRepository>(
      () => CarsRepositoryImpl(
        remoteDataSource: sl<CarsRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerFactory<CarsCubit>(() => CarsCubit(sl<CarsRepository>()));
  }
}

