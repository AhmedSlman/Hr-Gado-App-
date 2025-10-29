import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/salary_repository.dart';
import 'salary_states.dart';

class SalaryCubit extends Cubit<SalaryStates> {
  final SalaryRepository repository;
  SalaryCubit(this.repository) : super(SalaryInitial());
  static SalaryCubit get(context) => BlocProvider.of(context);

  Future<void> getMySalarySummary() async {
    emit(SalaryLoading());

    final result = await repository.getMySalarySummary();

    result.fold(
      (failure) {
        print('🔍 SalaryCubit - Failure: ${failure.message}');
        emit(SalaryError(failure.message));
      },
      (salarySummary) {
        print(
          '🔍 SalaryCubit - Success: ${salarySummary.data.netMonthlySalary}',
        );
        emit(SalarySuccess(salarySummary));
      },
    );
  }
}
