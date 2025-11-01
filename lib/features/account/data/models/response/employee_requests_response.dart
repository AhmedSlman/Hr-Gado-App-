import 'employee_request_model.dart';

class EmployeeRequestsResponse {
  final List<EmployeeRequestModel> requests;

  const EmployeeRequestsResponse({required this.requests});

  factory EmployeeRequestsResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? []) as List;
    final requests = data
        .map((item) => EmployeeRequestModel.fromJson(
              item as Map<String, dynamic>,
            ))
        .toList();

    return EmployeeRequestsResponse(requests: requests);
  }
}

