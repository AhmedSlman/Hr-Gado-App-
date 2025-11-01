import 'account_repository.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/employee_requests_response.dart';
import '../models/response/employees_response.dart';
import '../models/response/personal_data_model.dart';
import '../models/response/advance_details_model.dart';
import '../models/response/vacation_details_model.dart';
import '../models/response/employee_reports_response.dart';
import '../models/response/employee_report_details_model.dart';
import '../../../../../features/vacation/data/models/response/api_message_response.dart';
import '../../../../../core/error/result_extensions.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<EmployeeRequestsResponse>> fetchEmployeeRequests() async {
    final result = await remoteDataSource.fetchEmployeeRequests();
    return result;
  }

  @override
  Future<Result<EmployeesResponse>> fetchEmployees() async {
    final result = await remoteDataSource.fetchEmployees();
    return result;
  }

  @override
  Future<Result<PersonalDataModel>> fetchPersonalData(int employeeId) async {
    final result = await remoteDataSource.fetchPersonalData(employeeId);
    return result;
  }

  @override
  Future<Result<PersonalDataModel>> fetchProfile() async {
    final result = await remoteDataSource.fetchProfile();
    return result;
  }

  @override
  Future<Result<AdvanceDetailsModel>> fetchAdvanceDetails(int requestId) async {
    final result = await remoteDataSource.fetchAdvanceDetails(requestId);
    return result;
  }

  @override
  Future<Result<VacationDetailsModel>> fetchVacationDetails(
    int requestId,
  ) async {
    final result = await remoteDataSource.fetchVacationDetails(requestId);
    return result;
  }

  @override
  Future<Result<EmployeeReportsResponse>> fetchEmployeeReports() async {
    final result = await remoteDataSource.fetchEmployeeReports();
    return result;
  }

  @override
  Future<Result<EmployeeReportDetailsModel>> fetchEmployeeReportDetails(
    int reportId,
  ) async {
    final result = await remoteDataSource.fetchEmployeeReportDetails(reportId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> updateReport(
    int reportId,
    Map<String, dynamic> formData,
  ) async {
    final result = await remoteDataSource.updateReport(reportId, formData);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> confirmReport(int reportId) async {
    final result = await remoteDataSource.confirmReport(reportId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> approveAdvance(int requestId) async {
    final result = await remoteDataSource.approveAdvance(requestId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> rejectAdvance(int requestId) async {
    final result = await remoteDataSource.rejectAdvance(requestId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> approveLeave(int requestId) async {
    final result = await remoteDataSource.approveLeave(requestId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> rejectLeave(int requestId) async {
    final result = await remoteDataSource.rejectLeave(requestId);
    return result;
  }

  @override
  Future<Result<ApiMessageResponse>> reportIssue(
    Map<String, dynamic> formData,
  ) async {
    final result = await remoteDataSource.reportIssue(formData);
    return result;
  }
}
