import 'package:go_router/go_router.dart';
import 'salary_names.dart';
import '../presentation/views/salary_view.dart';

class SalaryRouter {
  static List<GoRoute> get routes => [
    // Salary Screen
    GoRoute(
      path: SalaryRoutes.salary,
      builder: (context, state) => const SalaryView(),
    ),
  ];
}
