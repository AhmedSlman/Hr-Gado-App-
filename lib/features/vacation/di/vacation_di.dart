import 'package:hr_app/core/network/api_consumer.dart';

import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/vacation_repository.dart';
import '../data/repository/vacation_repository_impl.dart';
import '../logic/vacation_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for Vacation feature
class VacationDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<VacationRemoteDataSource>(
      () => VacationRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<VacationLocalDataSource>(
      () => VacationLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<VacationRepository>(
      () => VacationRepositoryImpl(
        remoteDataSource: sl<VacationRemoteDataSource>(),
      ),
    );

    // Cubit as lazy singleton to ensure single shared instance across UI
    sl.registerLazySingleton<VacationCubit>(
      () => VacationCubit(sl<VacationRepository>()),
    );
  }
}
