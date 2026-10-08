import 'dart:async';
import '../../../core/common/salary_updates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/salary_repository.dart';
import 'salary_states.dart';

class SalaryCubit extends Cubit<SalaryStates> {
  final SalaryRepository repository;
  late final StreamSubscription<void> _updates;
  int _request = 0;
  SalaryCubit(this.repository) : super(SalaryInitial()) {
    _updates = SalaryUpdates.changes.listen((_) => getMySalarySummary());
  }

  @override
  Future<void> close() async {
    await _updates.cancel();
    return super.close();
  }

  static SalaryCubit get(context) => BlocProvider.of(context);

  Future<void> getMySalarySummary() async {
    final request = ++_request;
    emit(SalaryLoading());

    final result = await repository.getMySalarySummary();

    if (isClosed || request != _request) return;
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
