import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/vacation_repository.dart';
import 'vacation_states.dart';
import '../data/models/request/vacation_submit_request.dart';
import '../data/models/response/vacation_list_response.dart';
import '../data/models/response/advance_list_response.dart';

class VacationCubit extends Cubit<VacationStates> {
  final VacationRepository repository;
  VacationCubit(this.repository) : super(VacationInitial());
  static VacationCubit get(context) => BlocProvider.of(context);

  Future<void> submit(VacationSubmitRequest request) async {
    emit(VacationSubmitting());
    final result = await repository.submit(request);
    result.fold(
      (failure) => emit(VacationSubmitError(failure.message)),
      (resp) => emit(VacationSubmitSuccess(resp.msg)),
    );
  }

  Future<void> submitAdvance(AdvanceSubmitRequest request) async {
    emit(VacationSubmitting());
    final result = await repository.submitAdvance(request);
    result.fold(
      (failure) => emit(VacationSubmitError(failure.message)),
      (resp) => emit(VacationSubmitSuccess(resp.msg)),
    );
  }

  Future<void> loadVacations() async {
    emit(VacationLoading());
    final result = await repository.fetchVacations();
    result.fold(
      (failure) => emit(VacationLoadError(failure.message)),
      (resp) => emit(VacationLoadSuccess(resp)),
    );
  }

  Future<void> loadAdvances() async {
    emit(AdvanceLoading());
    final result = await repository.fetchAdvances();
    result.fold(
      (failure) => emit(AdvanceLoadError(failure.message)),
      (resp) => emit(AdvanceLoadSuccess(resp)),
    );
  }
}
