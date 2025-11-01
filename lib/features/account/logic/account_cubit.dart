import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/account_repository.dart';
import 'account_states.dart';

class AccountCubit extends Cubit<AccountStates> {
  final AccountRepository repository;
  AccountCubit(this.repository) : super(AccountInitial());
  static AccountCubit get(context) => BlocProvider.of(context);

  Future<void> loadEmployeeRequests() async {
    emit(EmployeeRequestsLoading());
    final result = await repository.fetchEmployeeRequests();
    result.fold(
      (failure) => emit(EmployeeRequestsLoadError(failure.message)),
      (response) => emit(EmployeeRequestsLoadSuccess(response)),
    );
  }

  Future<void> loadEmployees() async {
    emit(EmployeesLoading());
    final result = await repository.fetchEmployees();
    result.fold(
      (failure) => emit(EmployeesLoadError(failure.message)),
      (response) => emit(EmployeesLoadSuccess(response)),
    );
  }

  Future<void> loadPersonalData(int employeeId) async {
    emit(PersonalDataLoading());
    final result = await repository.fetchPersonalData(employeeId);
    result.fold(
      (failure) => emit(PersonalDataLoadError(failure.message)),
      (data) => emit(PersonalDataLoadSuccess(data)),
    );
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await repository.fetchProfile();
    result.fold(
      (failure) => emit(ProfileLoadError(failure.message)),
      (data) => emit(ProfileLoadSuccess(data)),
    );
  }

  Future<void> loadAdvanceDetails(int requestId) async {
    emit(AdvanceDetailsLoading());
    final result = await repository.fetchAdvanceDetails(requestId);
    result.fold(
      (failure) => emit(AdvanceDetailsLoadError(failure.message)),
      (data) => emit(AdvanceDetailsLoadSuccess(data)),
    );
  }

  Future<void> loadVacationDetails(int requestId) async {
    emit(VacationDetailsLoading());
    final result = await repository.fetchVacationDetails(requestId);
    result.fold(
      (failure) => emit(VacationDetailsLoadError(failure.message)),
      (data) => emit(VacationDetailsLoadSuccess(data)),
    );
  }

  Future<void> loadEmployeeReports() async {
    emit(EmployeeReportsLoading());
    final result = await repository.fetchEmployeeReports();
    result.fold(
      (failure) => emit(EmployeeReportsLoadError(failure.message)),
      (response) => emit(EmployeeReportsLoadSuccess(response)),
    );
  }

  Future<void> loadEmployeeReportDetails(int reportId) async {
    emit(EmployeeReportDetailsLoading());
    final result = await repository.fetchEmployeeReportDetails(reportId);
    result.fold(
      (failure) => emit(EmployeeReportDetailsLoadError(failure.message)),
      (data) => emit(EmployeeReportDetailsLoadSuccess(data)),
    );
  }

  Future<void> updateReport(int reportId, Map<String, dynamic> formData) async {
    emit(UpdateReportProcessing());
    final result = await repository.updateReport(reportId, formData);
    result.fold(
      (failure) => emit(UpdateReportError(failure.message)),
      (response) => emit(UpdateReportSuccess(response.msg)),
    );
  }

  Future<void> confirmReport(int reportId) async {
    emit(ConfirmReportProcessing());
    final result = await repository.confirmReport(reportId);
    result.fold(
      (failure) => emit(ConfirmReportError(failure.message)),
      (response) => emit(ConfirmReportSuccess(response.msg)),
    );
  }

  Future<void> approveAdvance(int requestId) async {
    emit(ApproveAdvanceProcessing());
    final result = await repository.approveAdvance(requestId);
    result.fold(
      (failure) => emit(ApproveAdvanceError(failure.message)),
      (response) => emit(ApproveAdvanceSuccess(response.msg)),
    );
  }

  Future<void> rejectAdvance(int requestId) async {
    emit(RejectAdvanceProcessing());
    final result = await repository.rejectAdvance(requestId);
    result.fold(
      (failure) => emit(RejectAdvanceError(failure.message)),
      (response) => emit(RejectAdvanceSuccess(response.msg)),
    );
  }

  Future<void> approveLeave(int requestId) async {
    emit(ApproveLeaveProcessing());
    final result = await repository.approveLeave(requestId);
    result.fold(
      (failure) => emit(ApproveLeaveError(failure.message)),
      (response) => emit(ApproveLeaveSuccess(response.msg)),
    );
  }

  Future<void> rejectLeave(int requestId) async {
    emit(RejectLeaveProcessing());
    final result = await repository.rejectLeave(requestId);
    result.fold(
      (failure) => emit(RejectLeaveError(failure.message)),
      (response) => emit(RejectLeaveSuccess(response.msg)),
    );
  }

  Future<void> reportIssue(Map<String, dynamic> formData) async {
    emit(ReportIssueProcessing());
    final result = await repository.reportIssue(formData);
    result.fold(
      (failure) => emit(ReportIssueError(failure.message)),
      (response) => emit(ReportIssueSuccess(response.msg)),
    );
  }
}
