import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/salary/logic/report_cubit.dart';
import 'package:hr_app/features/salary/logic/salary_cubit.dart';
import 'package:hr_app/features/salary/presentation/views/report_details_view.dart';

import '../presentation/views/salary_view.dart';
import 'salary_names.dart';

class SalaryRouter {
  static List<GoRoute> get routes => [
    // Salary Screen
    GoRoute(
      path: SalaryRoutes.salary,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SalaryCubit>()..getMySalarySummary(),
        child: const SalaryView(),
      ),
    ),
    GoRoute(
      path: SalaryRoutes.reportDetails,

      builder: (context, state) {
        final report = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) =>
              sl<ReportCubit>()..getReportDetails(report['reportId'] as int),
          child: ReportDetailsView(
            reportId: report['reportId'] as int,
            date: report['date'] as String,
            metricsData: report['metricsData'] as Map<String, String>,
          ),
        );
      },
    ),
  ];
}
