import '../../../../../core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/request/create_car_request.dart';
import '../models/response/car_model.dart';
import '../models/response/create_car_response.dart';
import '../models/response/employee_model.dart';
import 'cars_repository.dart';

class CarsRepositoryImpl implements CarsRepository {
  final CarsRemoteDataSource remoteDataSource;

  CarsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<CarsListResponse>> getCars() async {
    return await remoteDataSource.getCars();
  }

  @override
  Future<Result<CarDetailsResponse>> getCarDetails(int carId) async {
    return await remoteDataSource.getCarDetails(carId);
  }

  @override
  Future<Result<CarDetailsResponse>> getMyCar() async {
    return await remoteDataSource.getMyCar();
  }

  @override
  Future<Result<EmployeesResponse>> getEmployees() async {
    return await remoteDataSource.getEmployees();
  }

  @override
  Future<Result<CreateCarResponse>> createCar(
    CreateCarRequest request,
  ) async {
    return await remoteDataSource.createCar(request);
  }

  @override
  Future<Result<CreateCarResponse>> updateCar(
    int carId,
    CreateCarRequest request,
  ) async {
    return await remoteDataSource.updateCar(carId, request);
  }

  @override
  Future<Result<CreateCarResponse>> deleteCar(int carId) async {
    return await remoteDataSource.deleteCar(carId);
  }
}

