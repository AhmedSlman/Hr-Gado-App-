import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/request/create_car_request.dart';
import '../data/repository/cars_repository.dart';
import 'cars_states.dart';

class CarsCubit extends Cubit<CarsStates> {
  final CarsRepository repository;
  CarsCubit(this.repository) : super(CarsInitial());
  static CarsCubit get(context) => BlocProvider.of(context);

  Future<void> getCars() async {
    emit(CarsLoading());
    final result = await repository.getCars();
    result.fold(
      (failure) => emit(CarsError(failure.message)),
      (carsResponse) => emit(CarsSuccess(carsResponse)),
    );
  }

  Future<void> getCarDetails(int carId) async {
    emit(CarDetailsLoading());
    final result = await repository.getCarDetails(carId);
    result.fold(
      (failure) => emit(CarDetailsError(failure.message)),
      (carDetails) => emit(CarDetailsSuccess(carDetails)),
    );
  }

  Future<void> getMyCar() async {
    emit(CarDetailsLoading());
    final result = await repository.getMyCar();
    result.fold(
      (failure) => emit(CarDetailsError(failure.message)),
      (carDetails) => emit(CarDetailsSuccess(carDetails)),
    );
  }

  Future<void> getEmployees() async {
    emit(EmployeesLoading());
    final result = await repository.getEmployees();
    result.fold(
      (failure) => emit(EmployeesError(failure.message)),
      (employees) => emit(EmployeesSuccess(employees)),
    );
  }

  Future<void> createCar(CreateCarRequest request) async {
    emit(CreateCarLoading());
    final result = await repository.createCar(request);
    result.fold((failure) => emit(CreateCarError(failure.message)), (response) {
      final msg = response.msg.isNotEmpty
          ? response.msg
          : 'تم إنشاء السيارة بنجاح';
      getCars();
      emit(CreateCarSuccess(msg));
    });
  }

  Future<void> updateCar(int carId, CreateCarRequest request) async {
    emit(UpdateCarLoading());
    final result = await repository.updateCar(carId, request);
    result.fold((failure) => emit(UpdateCarError(failure.message)), (response) {
      final msg = response.msg.isNotEmpty
          ? response.msg
          : 'تم تعديل السيارة بنجاح';
      // getCars();
      emit(UpdateCarSuccess(msg));
    });
  }

  Future<void> deleteCar(int carId) async {
    emit(DeleteCarLoading());
    final result = await repository.deleteCar(carId);
    result.fold((failure) => emit(DeleteCarError(failure.message)), (response) {
      final msg = response.msg.isNotEmpty
          ? response.msg
          : 'تم حذف السيارة بنجاح';
      getCars();
      emit(DeleteCarSuccess(msg));
    });
  }
}
