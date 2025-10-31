import 'package:dartz/dartz.dart';

import '../../../../../core/error/result_extensions.dart';
import '../../../../../core/network/api_consumer.dart';
import '../../models/request/create_car_request.dart';
import '../../models/response/car_model.dart';
import '../../models/response/create_car_response.dart';
import '../../models/response/employee_model.dart';
import '../../repository/endpoints.dart';

abstract class CarsRemoteDataSource {
  Future<Result<CarsListResponse>> getCars();
  Future<Result<CarDetailsResponse>> getCarDetails(int carId);
  Future<Result<CarDetailsResponse>> getMyCar();
  Future<Result<EmployeesResponse>> getEmployees();
  Future<Result<CreateCarResponse>> createCar(CreateCarRequest request);
  Future<Result<CreateCarResponse>> updateCar(
    int carId,
    CreateCarRequest request,
  );
  Future<Result<CreateCarResponse>> deleteCar(int carId);
}

class CarsRemoteDataSourceImpl implements CarsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  CarsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<CarsListResponse>> getCars() async {
    final result = await _apiConsumer.get<CarsListResponse>(
      path: CarsEndpoints.cars,
      parser: (json) => CarsListResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CarDetailsResponse>> getCarDetails(int carId) async {
    final result = await _apiConsumer.get<CarDetailsResponse>(
      path: CarsEndpoints.carDetails(carId),
      parser: (json) => CarDetailsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CarDetailsResponse>> getMyCar() async {
    final result = await _apiConsumer.get<CarDetailsResponse>(
      path: CarsEndpoints.myCar,
      parser: (json) => CarDetailsResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    final result = await _apiConsumer.get<EmployeesResponse>(
      path: CarsEndpoints.employees,
      parser: (json) => EmployeesResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateCarResponse>> createCar(CreateCarRequest request) async {
    final result = await _apiConsumer.post<CreateCarResponse>(
      path: CarsEndpoints.cars,
      body: request.toJson(),
      parser: (json) => CreateCarResponse.fromJson(json),
      isFormData: true,
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateCarResponse>> updateCar(
    int carId,
    CreateCarRequest request,
  ) async {
    final result = await _apiConsumer.put<CreateCarResponse>(
      path: CarsEndpoints.carDetails(carId),
      body: request.toJson(),
      parser: (json) => CreateCarResponse.fromJson(json),
      isFormData: true,
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }

  @override
  Future<Result<CreateCarResponse>> deleteCar(int carId) async {
    final result = await _apiConsumer.delete<CreateCarResponse>(
      path: CarsEndpoints.carDetails(carId),
      parser: (json) => CreateCarResponse.fromJson(json),
    );

    return result.fold(
      onSuccess: (data) => Right(data),
      onFailure: (failure) => Left(failure),
    );
  }
}
