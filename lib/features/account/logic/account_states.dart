import '../data/models/response/employee_requests_response.dart';
import '../data/models/response/employees_response.dart';
import '../data/models/response/personal_data_model.dart';
import '../data/models/response/advance_details_model.dart';
import '../data/models/response/vacation_details_model.dart';
import '../data/models/response/employee_reports_response.dart';
import '../data/models/response/employee_report_details_model.dart';

abstract class AccountStates {}

class AccountInitial extends AccountStates {}

class EmployeeRequestsLoading extends AccountStates {}

class EmployeeRequestsLoadSuccess extends AccountStates {
  final EmployeeRequestsResponse response;
  EmployeeRequestsLoadSuccess(this.response);
}

class EmployeeRequestsLoadError extends AccountStates {
  final String message;
  EmployeeRequestsLoadError(this.message);
}

class EmployeesLoading extends AccountStates {}

class EmployeesLoadSuccess extends AccountStates {
  final EmployeesResponse response;
  EmployeesLoadSuccess(this.response);
}

class EmployeesLoadError extends AccountStates {
  final String message;
  EmployeesLoadError(this.message);
}

class PersonalDataLoading extends AccountStates {}

class PersonalDataLoadSuccess extends AccountStates {
  final PersonalDataModel data;
  PersonalDataLoadSuccess(this.data);
}

class PersonalDataLoadError extends AccountStates {
  final String message;
  PersonalDataLoadError(this.message);
}

class ProfileLoading extends AccountStates {}

class ProfileLoadSuccess extends AccountStates {
  final PersonalDataModel data;
  ProfileLoadSuccess(this.data);
}

class ProfileLoadError extends AccountStates {
  final String message;
  ProfileLoadError(this.message);
}

class AdvanceDetailsLoading extends AccountStates {}

class AdvanceDetailsLoadSuccess extends AccountStates {
  final AdvanceDetailsModel data;
  AdvanceDetailsLoadSuccess(this.data);
}

class AdvanceDetailsLoadError extends AccountStates {
  final String message;
  AdvanceDetailsLoadError(this.message);
}

class VacationDetailsLoading extends AccountStates {}

class VacationDetailsLoadSuccess extends AccountStates {
  final VacationDetailsModel data;
  VacationDetailsLoadSuccess(this.data);
}

class VacationDetailsLoadError extends AccountStates {
  final String message;
  VacationDetailsLoadError(this.message);
}

class EmployeeReportsLoading extends AccountStates {}

class EmployeeReportsLoadSuccess extends AccountStates {
  final EmployeeReportsResponse response;
  EmployeeReportsLoadSuccess(this.response);
}

class EmployeeReportsLoadError extends AccountStates {
  final String message;
  EmployeeReportsLoadError(this.message);
}

class EmployeeReportDetailsLoading extends AccountStates {}

class EmployeeReportDetailsLoadSuccess extends AccountStates {
  final EmployeeReportDetailsModel data;
  EmployeeReportDetailsLoadSuccess(this.data);
}

class EmployeeReportDetailsLoadError extends AccountStates {
  final String message;
  EmployeeReportDetailsLoadError(this.message);
}

class UpdateReportProcessing extends AccountStates {}

class UpdateReportSuccess extends AccountStates {
  final String message;
  UpdateReportSuccess(this.message);
}

class UpdateReportError extends AccountStates {
  final String message;
  UpdateReportError(this.message);
}

class ConfirmReportProcessing extends AccountStates {}

class ConfirmReportSuccess extends AccountStates {
  final String message;
  ConfirmReportSuccess(this.message);
}

class ConfirmReportError extends AccountStates {
  final String message;
  ConfirmReportError(this.message);
}

class ApproveAdvanceProcessing extends AccountStates {}

class ApproveAdvanceSuccess extends AccountStates {
  final String message;
  ApproveAdvanceSuccess(this.message);
}

class ApproveAdvanceError extends AccountStates {
  final String message;
  ApproveAdvanceError(this.message);
}

class RejectAdvanceProcessing extends AccountStates {}

class RejectAdvanceSuccess extends AccountStates {
  final String message;
  RejectAdvanceSuccess(this.message);
}

class RejectAdvanceError extends AccountStates {
  final String message;
  RejectAdvanceError(this.message);
}

class ApproveLeaveProcessing extends AccountStates {}

class ApproveLeaveSuccess extends AccountStates {
  final String message;
  ApproveLeaveSuccess(this.message);
}

class ApproveLeaveError extends AccountStates {
  final String message;
  ApproveLeaveError(this.message);
}

class RejectLeaveProcessing extends AccountStates {}

class RejectLeaveSuccess extends AccountStates {
  final String message;
  RejectLeaveSuccess(this.message);
}

class RejectLeaveError extends AccountStates {
  final String message;
  RejectLeaveError(this.message);
}

class ReportIssueProcessing extends AccountStates {}

class ReportIssueSuccess extends AccountStates {
  final String message;
  ReportIssueSuccess(this.message);
}

class ReportIssueError extends AccountStates {
  final String message;
  ReportIssueError(this.message);
}
