import '../../../../../core/error/result_extensions.dart';
import '../models/request/create_deduction_request.dart';
import '../models/response/create_deduction_response.dart';
import '../models/response/deduction_model.dart';
import '../models/response/employee_model.dart';

abstract class SalaryDeductionRepository {
  Future<Result<DeductionsResponse>> getEmployeeDeductions();
  Future<Result<DeductionsResponse>> getManagerDeductions();
  Future<Result<EmployeesResponse>> getEmployees();
  Future<Result<CreateDeductionResponse>> createDeduction(
    CreateDeductionRequest request,
  );
}
