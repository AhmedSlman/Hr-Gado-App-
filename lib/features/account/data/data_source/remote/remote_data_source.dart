import 'package:dartz/dartz.dart';

import '../../../../../core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/employee_requests_response.dart';
import '../../models/response/employees_response.dart';
import '../../models/response/personal_data_model.dart';
import '../../models/response/advance_details_model.dart';
import '../../models/response/vacation_details_model.dart';
import '../../models/response/employee_reports_response.dart';
import '../../models/response/employee_report_details_model.dart';
import '../../../../../features/vacation/data/models/response/api_message_response.dart';
import '../../repository/endpoints.dart';

abstract class AccountRemoteDataSource {
  Future<Result<EmployeeRequestsResponse>> fetchEmployeeRequests();
  Future<Result<EmployeesResponse>> fetchEmployees();
  Future<Result<PersonalDataModel>> fetchPersonalData(int employeeId);
  Future<Result<PersonalDataModel>> fetchProfile();
  Future<Result<AdvanceDetailsModel>> fetchAdvanceDetails(int requestId);
  Future<Result<VacationDetailsModel>> fetchVacationDetails(int requestId);
  Future<Result<EmployeeReportsResponse>> fetchEmployeeReports();
  Future<Result<EmployeeReportDetailsModel>> fetchEmployeeReportDetails(
    int reportId,
  );
  Future<Result<ApiMessageResponse>> updateReport(
    int reportId,
    Map<String, dynamic> formData,
  );
  Future<Result<ApiMessageResponse>> confirmReport(int reportId);
  Future<Result<ApiMessageResponse>> approveAdvance(int requestId);
  Future<Result<ApiMessageResponse>> rejectAdvance(int requestId);
  Future<Result<ApiMessageResponse>> approveLeave(int requestId);
  Future<Result<ApiMessageResponse>> rejectLeave(int requestId);
  Future<Result<ApiMessageResponse>> reportIssue(Map<String, dynamic> formData);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AccountRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<EmployeeRequestsResponse>> fetchEmployeeRequests() async {
    final result = await _apiConsumer.get<EmployeeRequestsResponse>(
      path: AccountEndpoints.employeeRequests,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => EmployeeRequestsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeesResponse>> fetchEmployees() async {
    final result = await _apiConsumer.get<EmployeesResponse>(
      path: AccountEndpoints.employees,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => EmployeesResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<PersonalDataModel>> fetchPersonalData(int employeeId) async {
    final result = await _apiConsumer.get<PersonalDataModel>(
      path: AccountEndpoints.personalData(employeeId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        return PersonalDataModel.fromJson(data);
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<PersonalDataModel>> fetchProfile() async {
    final result = await _apiConsumer.get<PersonalDataModel>(
      path: AccountEndpoints.profile,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        return PersonalDataModel.fromJson(data);
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<AdvanceDetailsModel>> fetchAdvanceDetails(int requestId) async {
    final result = await _apiConsumer.get<AdvanceDetailsModel>(
      path: AccountEndpoints.advanceDetails(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        return AdvanceDetailsModel.fromJson(data);
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<VacationDetailsModel>> fetchVacationDetails(
    int requestId,
  ) async {
    final result = await _apiConsumer.get<VacationDetailsModel>(
      path: AccountEndpoints.vacationDetails(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        return VacationDetailsModel.fromJson(data);
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> approveAdvance(int requestId) async {
    final result = await _apiConsumer.put<ApiMessageResponse>(
      path: AccountEndpoints.approveAdvance(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> rejectAdvance(int requestId) async {
    final result = await _apiConsumer.put<ApiMessageResponse>(
      path: AccountEndpoints.rejectAdvance(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> approveLeave(int requestId) async {
    final result = await _apiConsumer.put<ApiMessageResponse>(
      path: AccountEndpoints.approveLeave(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> rejectLeave(int requestId) async {
    final result = await _apiConsumer.put<ApiMessageResponse>(
      path: AccountEndpoints.rejectLeave(requestId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeeReportsResponse>> fetchEmployeeReports() async {
    final result = await _apiConsumer.get<EmployeeReportsResponse>(
      path: AccountEndpoints.employeeReports,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => EmployeeReportsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeeReportDetailsModel>> fetchEmployeeReportDetails(
    int reportId,
  ) async {
    final result = await _apiConsumer.get<EmployeeReportDetailsModel>(
      path: AccountEndpoints.employeeReportDetails(reportId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) {
        final data = (json['data'] ?? {}) as Map<String, dynamic>;
        return EmployeeReportDetailsModel.fromJson(data);
      },
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> updateReport(
    int reportId,
    Map<String, dynamic> formData,
  ) async {
    final result = await _apiConsumer.put<ApiMessageResponse>(
      path: AccountEndpoints.updateReport(reportId),
      body: formData,
      headers: const {
        'Accept': 'application/vnd.api+json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> confirmReport(int reportId) async {
    final result = await _apiConsumer.post<ApiMessageResponse>(
      path: AccountEndpoints.confirmReport(reportId),
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ApiMessageResponse>> reportIssue(
    Map<String, dynamic> formData,
  ) async {
    final result = await _apiConsumer.post<ApiMessageResponse>(
      path: AccountEndpoints.reportIssue,
      body: formData,
      isFormData: true,
      headers: const {'Accept': 'application/vnd.api+json'},
      parser: (json) => ApiMessageResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
