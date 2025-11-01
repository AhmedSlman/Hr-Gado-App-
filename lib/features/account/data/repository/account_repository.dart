import '../../../../../core/error/result_extensions.dart';
import '../../../../../features/vacation/data/models/response/api_message_response.dart';
import '../models/response/employee_requests_response.dart';
import '../models/response/employees_response.dart';
import '../models/response/personal_data_model.dart';
import '../models/response/advance_details_model.dart';
import '../models/response/vacation_details_model.dart';
import '../models/response/employee_reports_response.dart';
import '../models/response/employee_report_details_model.dart';

abstract class AccountRepository {
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
