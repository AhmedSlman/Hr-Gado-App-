import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/salary_repository.dart';
import 'report_states.dart';

class ReportCubit extends Cubit<ReportState> {
  final SalaryRepository salaryRepository;

  ReportCubit({required this.salaryRepository}) : super(ReportInitial());

  Future<void> getReportDetails(
    int reportId,
  ) async {
    emit(ReportLoading());

    final result = await salaryRepository.getReportDetails(reportId);

    result.fold(
      (failure) {
        emit(ReportError(message: failure.message));
      },
      (reportResponse) {
        emit(
          ReportLoaded(
            reportData: reportResponse.data,
           
          ),
        );
      },
    );
  }
}
