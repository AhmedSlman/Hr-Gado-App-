import '../../../../../core/error/result_extensions.dart';
import '../models/request/create_car_request.dart';
import '../models/response/car_model.dart';
import '../models/response/create_car_response.dart';
import '../models/response/employee_model.dart';

abstract class CarsRepository {
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
