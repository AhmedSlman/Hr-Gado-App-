import 'package:hr_app/core/network/api_consumer.dart';

import '../../../../core/locator/service_locator.dart';
import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/meetings_repository.dart';
import '../data/repository/meetings_repository_impl.dart';
import '../logic/meetings_cubit.dart';

/// Dependency injection setup for Meetings feature
class MeetingsDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<MeetingsRemoteDataSource>(
      () => MeetingsRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<MeetingsLocalDataSource>(
      () => MeetingsLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<MeetingsRepository>(
      () => MeetingsRepositoryImpl(
        remoteDataSource: sl<MeetingsRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerFactory<MeetingsCubit>(
      () => MeetingsCubit(sl<MeetingsRepository>()),
    );
  }
}

