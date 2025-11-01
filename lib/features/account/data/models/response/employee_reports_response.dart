import 'employee_report_model.dart';

class EmployeeReportsResponse {
  final String key;
  final String msg;
  final List<EmployeeReportModel> reports;

  const EmployeeReportsResponse({
    required this.key,
    required this.msg,
    required this.reports,
  });

  factory EmployeeReportsResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? []) as List;
    final reports = data
        .map((item) => EmployeeReportModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return EmployeeReportsResponse(
      key: (json['key'] ?? '').toString(),
      msg: (json['msg'] ?? '').toString(),
      reports: reports,
    );
  }
}

