import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/salary_updates.dart';
import '../data/models/response/personal_reports_model.dart';
import '../data/repository/salary_repository.dart';

sealed class PersonalReportsState {}

class PersonalReportsLoading extends PersonalReportsState {}

class PersonalReportsLoaded extends PersonalReportsState {
  final List<PersonalReport> reports;
  PersonalReportsLoaded(this.reports);
}

class PersonalReportsError extends PersonalReportsState {
  final String message;
  PersonalReportsError(this.message);
}

class PersonalReportsCubit extends Cubit<PersonalReportsState> {
  final SalaryRepository repository;
  late final StreamSubscription<void> _updates;
  ReportFilters _filters = const ReportFilters();
  int _request = 0;
  PersonalReportsCubit(this.repository) : super(PersonalReportsLoading()) {
    _updates = SalaryUpdates.changes.listen((_) => load(_filters));
  }

  Future<void> load(ReportFilters filters) async {
    final request = ++_request;
    try {
      filters.toQuery();
      _filters = filters;
      emit(PersonalReportsLoading());
      final result = await repository.getPersonalReports(filters);
      if (isClosed || request != _request) return;
      result.fold(
        (failure) => emit(PersonalReportsError(failure.message)),
        (response) => emit(PersonalReportsLoaded(response.reports)),
      );
    } on ArgumentError {
      if (!isClosed && request == _request) {
        emit(
          PersonalReportsError('اختر شهراً من 1 إلى 12 وسنة من 2020 إلى 2030'),
        );
      }
    }
  }

  @override
  Future<void> close() async {
    await _updates.cancel();
    return super.close();
  }
}
