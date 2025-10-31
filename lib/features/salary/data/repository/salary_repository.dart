import '../../../../../core/error/result_extensions.dart';
import '../models/response/report_model.dart';
import '../models/response/salary_model.dart';

abstract class SalaryRepository {
  Future<Result<SalarySummaryResponse>> getMySalarySummary();
  Future<Result<ReportResponse>> getReportDetails(int reportId);
}
