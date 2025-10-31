import '../data/models/response/car_model.dart';
import '../data/models/response/employee_model.dart';

abstract class CarsStates {}

class CarsInitial extends CarsStates {}

// Cars list states
class CarsLoading extends CarsStates {}

class CarsSuccess extends CarsStates {
  final CarsListResponse carsResponse;
  CarsSuccess(this.carsResponse);
}

class CarsError extends CarsStates {
  final String message;
  CarsError(this.message);
}

// Car details states
class CarDetailsLoading extends CarsStates {}

class CarDetailsSuccess extends CarsStates {
  final CarDetailsResponse carDetailsResponse;
  CarDetailsSuccess(this.carDetailsResponse);
}

class CarDetailsError extends CarsStates {
  final String message;
  CarDetailsError(this.message);
}

// Employees states
class EmployeesLoading extends CarsStates {}

class EmployeesSuccess extends CarsStates {
  final EmployeesResponse employeesResponse;
  EmployeesSuccess(this.employeesResponse);
}

class EmployeesError extends CarsStates {
  final String message;
  EmployeesError(this.message);
}

// Create car states
class CreateCarLoading extends CarsStates {}

class CreateCarSuccess extends CarsStates {
  final String message;
  CreateCarSuccess(this.message);
}

class CreateCarError extends CarsStates {
  final String message;
  CreateCarError(this.message);
}

// Update car states
class UpdateCarLoading extends CarsStates {}

class UpdateCarSuccess extends CarsStates {
  final String message;
  UpdateCarSuccess(this.message);
}

class UpdateCarError extends CarsStates {
  final String message;
  UpdateCarError(this.message);
}

// Delete car states
class DeleteCarLoading extends CarsStates {}

class DeleteCarSuccess extends CarsStates {
  final String message;
  DeleteCarSuccess(this.message);
}

class DeleteCarError extends CarsStates {
  final String message;
  DeleteCarError(this.message);
}

