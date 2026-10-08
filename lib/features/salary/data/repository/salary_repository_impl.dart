import '../models/response/personal_reports_model.dart';
import '../../../../../core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/report_model.dart';
import '../models/response/salary_model.dart';
import 'salary_repository.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final SalaryRemoteDataSource remoteDataSource;

  SalaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<PersonalReportsResponse>> getPersonalReports(
    ReportFilters filters,
  ) => remoteDataSource.getPersonalReports(filters);

  @override
  Future<Result<SalarySummaryResponse>> getMySalarySummary() async {
    final result = await remoteDataSource.getMySalarySummary();
    return result;
  }

  @override
  Future<Result<ReportResponse>> getReportDetails(int reportId) async {
    final result = await remoteDataSource.getReportDetails(reportId);
    return result;
  }
}
