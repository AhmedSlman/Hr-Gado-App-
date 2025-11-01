import 'package:hr_app/features/account/data/models/employee_request_type.dart';

class EmployeeRequestDetailsExtra {
  final EmployeeRequestType requestType;
  final int requestId;

  const EmployeeRequestDetailsExtra({
    required this.requestType,
    required this.requestId,
  });
}

class PersonalDataExtra {
  final int employeeId;

  const PersonalDataExtra({required this.employeeId});
}

class EmployeeReportDetailsExtra {
  final int reportId;

  const EmployeeReportDetailsExtra({required this.reportId});
}
