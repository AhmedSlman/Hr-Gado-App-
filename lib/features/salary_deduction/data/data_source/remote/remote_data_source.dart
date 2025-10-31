import 'package:dartz/dartz.dart';

import '../../../../../core/error/result_extensions.dart';
import '../../../../../core/network/api_consumer.dart';
import '../../models/request/create_deduction_request.dart';
import '../../models/response/create_deduction_response.dart';
import '../../models/response/deduction_model.dart';
import '../../models/response/employee_model.dart';
import '../../repository/endpoints.dart';

abstract class SalaryDeductionRemoteDataSource {
  Future<Result<DeductionsResponse>> getEmployeeDeductions();
  Future<Result<DeductionsResponse>> getManagerDeductions();
  Future<Result<EmployeesResponse>> getEmployees();
  Future<Result<CreateDeductionResponse>> createDeduction(
    CreateDeductionRequest request,
  );
}

class SalaryDeductionRemoteDataSourceImpl
    implements SalaryDeductionRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SalaryDeductionRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<DeductionsResponse>> getEmployeeDeductions() async {
    final result = await _apiConsumer.get<DeductionsResponse>(
      path: SalaryDeductionEndpoints.employeeDeductions,
      parser: (json) => DeductionsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<DeductionsResponse>> getManagerDeductions() async {
    final result = await _apiConsumer.get<DeductionsResponse>(
      path: SalaryDeductionEndpoints.managerDeductions,
      parser: (json) => DeductionsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    final result = await _apiConsumer.get<EmployeesResponse>(
      path: SalaryDeductionEndpoints.employees,
      parser: (json) => EmployeesResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateDeductionResponse>> createDeduction(
    CreateDeductionRequest request,
  ) async {
    final result = await _apiConsumer.post<CreateDeductionResponse>(
      path: SalaryDeductionEndpoints.deductions,
      body: request.toJson(),
      parser: (json) => CreateDeductionResponse.fromJson(json),
      isFormData: true,
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
