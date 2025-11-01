import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/time_sheet_repository.dart';
import '../data/models/request/time_sheet_request.dart';
import '../data/models/request/permission_request.dart';
import 'time_sheet_states.dart';

class TimeSheetCubit extends Cubit<TimeSheetStates> {
  final TimeSheetRepository repository;
  TimeSheetCubit(this.repository) : super(TimeSheetInitial());
  static TimeSheetCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems({int? month, int? year}) async {
    emit(TimeSheetLoading());
    final result = await repository.fetchItems(
      TimeSheetRequest(month: month, year: year),
    );

    result.fold(
      (failure) => emit(TimeSheetLoadError(failure.message)),
      (items) => emit(TimeSheetLoadSuccess(items)),
    );
  }

  Future<void> submitPermissionRequest(
    String permissionType,
    String durationText,
  ) async {
    emit(PermissionRequestProcessing());
    
    final request = PermissionRequest(
      date: PermissionRequest.getCurrentDate(),
      type: PermissionRequest.convertPermissionType(permissionType),
      durationMinutes: PermissionRequest.parseDuration(durationText),
    );

    final result = await repository.submitPermissionRequest(request);

    result.fold(
      (failure) => emit(PermissionRequestError(failure.message)),
      (message) => emit(PermissionRequestSuccess(message)),
    );
  }
}
