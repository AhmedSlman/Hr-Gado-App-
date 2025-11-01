import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'account_names.dart';
import 'account_route_extra.dart';
import '../data/models/employee_request_type.dart';
import '../logic/account_cubit.dart';
import '../presentation/views/account_view.dart';
import '../presentation/views/complaints_suggestions_view.dart';
import '../presentation/views/employee_report_details_view.dart';
import '../presentation/views/employee_reports_view.dart';
import '../presentation/views/employee_request_details_view.dart';
import '../presentation/views/employee_requests_view.dart';
import '../presentation/views/employees_view.dart';
import '../presentation/views/personal_data_view.dart';
import '../presentation/views/profile_view.dart';

class AccountRouter {
  static List<GoRoute> get routes => [
    // Account Screen
    GoRoute(
      path: AccountRoutes.account,
      builder: (context, state) => const AccountView(),
    ),
    // Profile Screen
    GoRoute(
      path: AccountRoutes.profile,
      builder: (context, state) {
        final cubit = sl<AccountCubit>()..loadProfile();
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: const ProfileView(),
        );
      },
    ),
    // Personal Data Screen
    GoRoute(
      path: AccountRoutes.personalData,
      builder: (context, state) {
        final extra = state.extra as PersonalDataExtra?;
        final employeeId = extra?.employeeId ?? 0;
        final cubit = sl<AccountCubit>()..loadPersonalData(employeeId);
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: PersonalDataView(employeeId: employeeId),
        );
      },
    ),
    // Employees Screen
    GoRoute(
      path: AccountRoutes.employees,
      builder: (context, state) {
        final cubit = sl<AccountCubit>()..loadEmployees();
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: const EmployeesView(),
        );
      },
    ),
    // Employee Reports Screen
    GoRoute(
      path: AccountRoutes.employeeReports,
      builder: (context, state) {
        final cubit = sl<AccountCubit>()..loadEmployeeReports();
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: const EmployeeReportsView(),
        );
      },
    ),
    // Employee Report Details Screen
    GoRoute(
      path: AccountRoutes.employeeReportDetails,
      builder: (context, state) {
        final extra = state.extra as EmployeeReportDetailsExtra?;
        final reportId = extra?.reportId ?? 0;
        final cubit = sl<AccountCubit>()..loadEmployeeReportDetails(reportId);
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: EmployeeReportDetailsView(reportId: reportId),
        );
      },
    ),
    // Employee Request Details Screen (request details)
    GoRoute(
      path: AccountRoutes.employeeRequestDetails,
      builder: (context, state) {
        final extra = state.extra as EmployeeRequestDetailsExtra?;
        final requestType = extra?.requestType ?? EmployeeRequestType.vacation;
        final requestId = extra?.requestId ?? 0;

        final cubit = sl<AccountCubit>();

        if (requestType == EmployeeRequestType.vacation) {
          cubit.loadVacationDetails(requestId);
        } else {
          // Load advance details for normal and long_term advances
          cubit.loadAdvanceDetails(requestId);
        }

        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: EmployeeRequsetDetailsView(
            requestType: requestType,
            requestId: requestId,
          ),
        );
      },
    ),
    // Employee Requests Screen (list of requests)
    GoRoute(
      path: AccountRoutes.employeeRequests,
      builder: (context, state) {
        final cubit = sl<AccountCubit>()..loadEmployeeRequests();
        return BlocProvider<AccountCubit>.value(
          value: cubit,
          child: const EmployeeRequestsView(),
        );
      },
    ),
    // Complaints and Suggestions Screen
    GoRoute(
      path: AccountRoutes.complaintsSuggestions,
      builder: (context, state) {
        return BlocProvider<AccountCubit>.value(
          value: sl<AccountCubit>(),
          child: const ComplaintsSuggestionsView(),
        );
      },
    ),
  ];
}
