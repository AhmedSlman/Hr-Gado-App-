import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/notifications_repository.dart';
import '../data/repository/notifications_repository_impl.dart';
import '../logic/notifications_cubit.dart';

class NotificationsDI {
  static void setup() {
    // Remote Data Source
    sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // Repository
    sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        remoteDataSource: sl<NotificationsRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerLazySingleton<NotificationsCubit>(
      () => NotificationsCubit(sl<NotificationsRepository>()),
    );
  }
}

