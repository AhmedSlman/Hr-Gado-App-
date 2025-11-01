import 'package:get_it/get_it.dart';
import 'package:hr_app/features/account/di/account_di.dart';
import 'package:hr_app/features/meetings/di/meetings_di.dart';

// Import feature DI setups
import '../../features/auth/di/auth_di.dart';
import '../../features/home/di/home_di.dart';
import '../../features/news/di/news_di.dart';
import '../../features/cars/di/cars_di.dart';
import '../../features/time_sheet/di/time_sheet_di.dart';
import '../../features/vacation/di/vacation_di.dart';
import '../../features/salary/di/salary_di.dart';
import '../../features/salary_deduction/di/salary_deduction_di.dart';
import '../cache/hive_service.dart';
import '../cache/init_hive.dart';
import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../network/network_config.dart';
import '../utils/user_helper.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Service locator setup class
class ServiceLocator {
  /// Initialize all core services
  static Future<void> init() async {
    // Initialize Hive first
    await HiveInit.init();

    // Initialize UserHelper
    await UserHelper.initialize();

    // Register core services
    sl.registerLazySingleton<HiveService>(() => HiveService());

    // Register network services
    sl.registerLazySingleton<NetworkConfig>(
      () => NetworkConfig.development, // Change to .production for production
    );

    sl.registerLazySingleton<DioConsumer>(
      () => DioConsumer(config: sl<NetworkConfig>()),
    );

    sl.registerLazySingleton<ApiConsumer>(() => sl<DioConsumer>());

    // Register feature services
    AuthDI.setup();
    HomeDI.setup();
    TimeSheetDI.setup();
    VacationDI.setup();
    SalaryDI.setup();
    NewsDI.setup();
    MeetingsDI.setup();
    CarsDI.setup();
    SalaryDeductionDI.setup();
    AccountDI.setup();
  }
}
