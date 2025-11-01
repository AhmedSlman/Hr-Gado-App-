import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/request/create_deduction_request.dart';
import '../data/repository/salary_deduction_repository.dart';
import 'salary_deduction_states.dart';

class SalaryDeductionCubit extends Cubit<SalaryDeductionStates> {
  final SalaryDeductionRepository repository;
  SalaryDeductionCubit(this.repository) : super(SalaryDeductionInitial());
  static SalaryDeductionCubit get(context) => BlocProvider.of(context);

  Future<void> getEmployeeDeductions() async {
    emit(SalaryDeductionLoading());
    final result = await repository.getEmployeeDeductions();
    result.fold(
      (failure) => emit(SalaryDeductionError(failure.message)),
      (deductionsResponse) => emit(SalaryDeductionSuccess(deductionsResponse)),
    );
  }

  Future<void> getManagerDeductions() async {
    emit(SalaryDeductionLoading());
    final result = await repository.getManagerDeductions();
    result.fold(
      (failure) => emit(SalaryDeductionError(failure.message)),
      (deductionsResponse) => emit(SalaryDeductionSuccess(deductionsResponse)),
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

  Future<void> createDeduction(CreateDeductionRequest request) async {
    emit(CreateDeductionLoading());
    final result = await repository.createDeduction(request);
    result.fold((failure) => emit(CreateDeductionError(failure.message)), (
      response,
    ) {
      final msg = response.msg.isNotEmpty
          ? response.msg
          : 'تم إنشاء الخصم بنجاح';
      // getManagerDeductions(); // بعد الإضافة، نحدث قائمة المدير
      emit(CreateDeductionSuccess(msg));
    });
  }
}
