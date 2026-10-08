import '../../models/response/employee_salary_type.dart';
import '../../models/response/personal_reports_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/result_extensions.dart';
import '../../../../../core/network/api_consumer.dart';
import '../../models/response/report_model.dart';
import '../../models/response/salary_model.dart';
import '../../repository/endpoints.dart';

abstract class SalaryRemoteDataSource {
  Future<Result<SalarySummaryResponse>> getMySalarySummary();
  Future<Result<ReportResponse>> getReportDetails(int reportId);
  Future<Result<PersonalReportsResponse>> getPersonalReports(
    ReportFilters filters,
  );
}

class SalaryRemoteDataSourceImpl implements SalaryRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SalaryRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<PersonalReportsResponse>> getPersonalReports(
    ReportFilters filters,
  ) async {
    final result = await _apiConsumer.get<PersonalReportsResponse>(
      path: SalaryEndpoints.personalReports,
      queryParameters: filters.toQuery(),
      parser: (json) =>
          PersonalReportsResponse.fromJson(json, currentReportType()),
    );
    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<SalarySummaryResponse>> getMySalarySummary() async {
    final result = await _apiConsumer.get<SalarySummaryResponse>(
      path: SalaryEndpoints.mySalarySummary,
      parser: (json) => SalarySummaryResponse.fromJson(
        json,
        employeeType: currentSalaryType(),
      ),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<ReportResponse>> getReportDetails(int reportId) async {
    final result = await _apiConsumer.get<ReportResponse>(
      path: '${SalaryEndpoints.reportDetails}/$reportId',
      parser: (json) => ReportResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
