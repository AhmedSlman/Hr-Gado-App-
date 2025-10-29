import 'package:hr_app/core/network/api_consumer.dart';

import '../../../../core/locator/service_locator.dart';
import '../data/data_source/local/local_data_source.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/salary_repository.dart';
import '../data/repository/salary_repository_impl.dart';
import '../logic/report_cubit.dart';
import '../logic/salary_cubit.dart';

/// Dependency injection setup for Salary feature
class SalaryDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<SalaryRemoteDataSource>(
      () => SalaryRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    sl.registerLazySingleton<SalaryLocalDataSource>(
      () => SalaryLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<SalaryRepository>(
      () =>
          SalaryRepositoryImpl(remoteDataSource: sl<SalaryRemoteDataSource>()),
    );

    // Cubits
    sl.registerFactory<SalaryCubit>(() => SalaryCubit(sl<SalaryRepository>()));
    sl.registerFactory<ReportCubit>(
      () => ReportCubit(salaryRepository: sl<SalaryRepository>()),
    );
  }
}
