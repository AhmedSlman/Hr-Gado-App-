import 'package:hr_app/core/network/api_consumer.dart';

import '../../../../core/locator/service_locator.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/salary_deduction_repository.dart';
import '../data/repository/salary_deduction_repository_impl.dart';
import '../logic/salary_deduction_cubit.dart';

/// Dependency injection setup for Salary Deduction feature
class SalaryDeductionDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<SalaryDeductionRemoteDataSource>(
      () => SalaryDeductionRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // Repository
    sl.registerLazySingleton<SalaryDeductionRepository>(
      () => SalaryDeductionRepositoryImpl(
        remoteDataSource: sl<SalaryDeductionRemoteDataSource>(),
      ),
    );

    // Cubit
    sl.registerFactory<SalaryDeductionCubit>(
      () => SalaryDeductionCubit(sl<SalaryDeductionRepository>()),
    );
  }
}
