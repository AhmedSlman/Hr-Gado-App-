class AccountEndpoints {
  static const String employeeRequests = '/employee/employee-requests';
  static const String employees = '/employee/manager-employees';
  static String personalData(int employeeId) =>
      '/employee/manager-employees/$employeeId';
  static String advanceDetails(int requestId) =>
      '/employee/advance-details/$requestId';
  static String vacationDetails(int requestId) =>
      '/employee/leave-details/$requestId';
  static String approveAdvance(int requestId) =>
      '/employee/approve-advance/$requestId';
  static String rejectAdvance(int requestId) =>
      '/employee/reject-advance/$requestId';
  static String approveLeave(int requestId) =>
      '/employee/approve-leave/$requestId';
  static String rejectLeave(int requestId) =>
      '/employee/reject-leave/$requestId';
  static const String employeeReports = '/employee/employees-reports';
  static String employeeReportDetails(int reportId) =>
      '/employee/employees-reports/$reportId';
}
