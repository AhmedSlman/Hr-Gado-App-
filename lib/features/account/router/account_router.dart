import 'package:go_router/go_router.dart';
import 'account_names.dart';
import '../presentation/views/account_view.dart';
import '../presentation/views/personal_data_view.dart';
import '../presentation/views/employees_view.dart';
import '../presentation/views/employee_request_details_view.dart';
import '../presentation/views/employee_requests_view.dart';

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
    // Employee Reports Screen (request details)
    GoRoute(
      path: AccountRoutes.employeeReports,
      builder: (context, state) => const EmployeeRequsetDetailsView(),
    ),
    // Employee Requests Screen (list of requests)
    GoRoute(
      path: AccountRoutes.employeeRequests,
      builder: (context, state) => const EmployeeRequestsView(),
    ),
  ];
}
