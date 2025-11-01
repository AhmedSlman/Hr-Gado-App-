import 'package:hr_app/core/network/api_consumer.dart';

import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/time_sheet_repository.dart';
import '../data/repository/time_sheet_repository_impl.dart';
import '../logic/time_sheet_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for TimeSheet feature
class TimeSheetDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<TimeSheetRemoteDataSource>(
      () => TimeSheetRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<TimeSheetLocalDataSource>(
      () => TimeSheetLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<TimeSheetRepository>(
      () => TimeSheetRepositoryImpl(
        remoteDataSource: sl<TimeSheetRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerLazySingleton<TimeSheetCubit>(
      () => TimeSheetCubit(sl<TimeSheetRepository>()),
    );
  }
}
