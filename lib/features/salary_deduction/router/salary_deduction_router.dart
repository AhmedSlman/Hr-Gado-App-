import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';

import '../logic/salary_deduction_cubit.dart';
import '../presentation/views/add_deduction_view.dart';
import '../presentation/views/salary_deduction_view.dart';
import 'salary_deduction_names.dart';

class SalaryDeductionRouter {
  static List<GoRoute> get routes => [
    // Salary Deductions Screen
    GoRoute(
      path: SalaryDeductionRoutes.deductions,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SalaryDeductionCubit>(),
        child: const SalaryDeductionView(),
      ),
    ),
    // Add Deduction Screen
    GoRoute(
      path: SalaryDeductionRoutes.addDeduction,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SalaryDeductionCubit>(),
        child: AddDeductionView(),
      ),
    ),
  ];
}
