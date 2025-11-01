import 'package:hr_app/core/network/api_consumer.dart';

import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/account_repository.dart';
import '../data/repository/account_repository_impl.dart';
import '../logic/account_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for Account feature
class AccountDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<AccountLocalDataSource>(
      () => AccountLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(
        remoteDataSource: sl<AccountRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerLazySingleton<AccountCubit>(
      () => AccountCubit(sl<AccountRepository>()),
    );
  }
}
