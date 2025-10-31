import '../../../../../core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/create_deduction_request.dart';
import '../models/response/create_deduction_response.dart';
import '../models/response/deduction_model.dart';
import '../models/response/employee_model.dart';
import 'salary_deduction_repository.dart';

class SalaryDeductionRepositoryImpl implements SalaryDeductionRepository {
  final SalaryDeductionRemoteDataSource remoteDataSource;

  SalaryDeductionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<DeductionsResponse>> getEmployeeDeductions() async {
    return await remoteDataSource.getEmployeeDeductions();
  }

  @override
  Future<Result<DeductionsResponse>> getManagerDeductions() async {
    return await remoteDataSource.getManagerDeductions();
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    return await remoteDataSource.getEmployees();
  }

  @override
  Future<Result<CreateDeductionResponse>> createDeduction(
    CreateDeductionRequest request,
  ) async {
    return await remoteDataSource.createDeduction(request);
  }
}
