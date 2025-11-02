import '../../../../core/network/api_consumer.dart';
import '../data/data_source/remote/remote_data_source.dart';
import '../data/repository/rules_repository.dart';
import '../data/repository/rules_repository_impl.dart';
import '../logic/rules_cubit.dart';
import '../../../../core/locator/service_locator.dart';

/// Dependency injection setup for Rules feature
class RulesDI {
  /// Setup feature dependencies
  static void setup() {
    // Data Sources
    sl.registerLazySingleton<RulesRemoteDataSource>(
      () => RulesRemoteDataSourceImpl(sl<ApiConsumer>()),
    );

    // Repository
    sl.registerLazySingleton<RulesRepository>(
      () => RulesRepositoryImpl(remoteDataSource: sl<RulesRemoteDataSource>()),
    );

    // Cubit
    sl.registerFactory<RulesCubit>(() => RulesCubit(sl<RulesRepository>()));
  }
}
