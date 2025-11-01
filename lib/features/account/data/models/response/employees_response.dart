import 'employee_model.dart';

class EmployeesResponse {
  final List<EmployeeModel> employees;

  const EmployeesResponse({required this.employees});

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? []) as List;
    final employees = data
        .map((item) => EmployeeModel.fromJson(
              item as Map<String, dynamic>,
            ))
        .toList();

    return EmployeesResponse(employees: employees);
  }
}

