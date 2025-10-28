import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/time_sheet_repository.dart';
import '../data/models/request/time_sheet_request.dart';
import '../data/models/response/time_sheet_model.dart';
import '../../../../../core/error/result_extensions.dart';
import 'time_sheet_states.dart';

class TimeSheetCubit extends Cubit<TimeSheetStates> {
  final TimeSheetRepository repository;
  TimeSheetCubit(this.repository) : super(TimeSheetInitial());
  static TimeSheetCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    final result = await repository.fetchItems(const TimeSheetRequest());

    // result.fold(
    //   (failure) => emit(TimeSheetError(failure.message)),
    //   (items) => emit(TimeSheetSuccess(items)),
    // );
  }
}
