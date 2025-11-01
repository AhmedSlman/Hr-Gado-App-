import 'package:go_router/go_router.dart';
import 'account_names.dart';
import 'account_route_extra.dart';
import '../data/models/employee_request_type.dart';
import '../presentation/views/account_view.dart';
import '../presentation/views/complaints_suggestions_view.dart';
import '../presentation/views/employee_report_details_view.dart';
import '../presentation/views/employee_reports_view.dart';
import '../presentation/views/employee_request_details_view.dart';
import '../presentation/views/employee_requests_view.dart';
import '../presentation/views/employees_view.dart';
import '../presentation/views/personal_data_view.dart';

class AccountRouter {
  static List<GoRoute> get routes => [
    // Account Screen
    GoRoute(
      path: AccountRoutes.account,
      builder: (context, state) => const AccountView(),
    ),
    // Personal Data Screen
    GoRoute(
      path: AccountRoutes.personalData,
      builder: (context, state) => const PersonalDataView(),
    ),
    // Employees Screen
    GoRoute(
      path: AccountRoutes.employees,
      builder: (context, state) => const EmployeesView(),
    ),
    // Employee Reports Screen
    GoRoute(
      path: AccountRoutes.employeeReports,
      builder: (context, state) => const EmployeeReportsView(),
    ),
    // Employee Report Details Screen
    GoRoute(
      path: AccountRoutes.employeeReportDetails,
      builder: (context, state) => const EmployeeReportDetailsView(),
    ),
    // Employee Request Details Screen (request details)
    GoRoute(
      path: AccountRoutes.employeeRequestDetails,
      builder: (context, state) {
        final extra = state.extra as EmployeeRequestDetailsExtra?;
        final requestType = extra?.requestType ?? EmployeeRequestType.vacation;
        return EmployeeRequsetDetailsView(requestType: requestType);
      },
    ),
    // Employee Requests Screen (list of requests)
    GoRoute(
      path: AccountRoutes.employeeRequests,
      builder: (context, state) => const EmployeeRequestsView(),
    ),
    // Complaints and Suggestions Screen
    GoRoute(
      path: AccountRoutes.complaintsSuggestions,
      builder: (context, state) => const ComplaintsSuggestionsView(),
    ),
  ];
}
