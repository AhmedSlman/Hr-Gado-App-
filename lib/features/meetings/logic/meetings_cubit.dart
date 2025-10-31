import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/request/create_meeting_request.dart';
import '../data/repository/meetings_repository.dart';
import 'meetings_states.dart';

class MeetingsCubit extends Cubit<MeetingsStates> {
  final MeetingsRepository repository;
  MeetingsCubit(this.repository) : super(MeetingsInitial());
  static MeetingsCubit get(context) => BlocProvider.of(context);

  Future<void> getMyMeetings() async {
    emit(MeetingsLoading());

    final result = await repository.getMyMeetings();

    result.fold(
      (failure) {
        print('🔍 MeetingsCubit - Failure: ${failure.message}');
        emit(MeetingsError(failure.message));
      },
      (meetingsResponse) {
        print(
          '🔍 MeetingsCubit - Success: ${meetingsResponse.data.length} meetings',
        );
        emit(MeetingsSuccess(meetingsResponse));
      },
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

  Future<void> createMeeting(CreateMeetingRequest request) async {
    emit(CreateMeetingLoading());

    final result = await repository.createMeeting(request);

    result.fold((failure) => emit(CreateMeetingError(failure.message)), (resp)  {
      final msg = resp.msg.isNotEmpty ? resp.msg : 'تم اضافة الاجتماع بنجاح';
       getMyMeetings();
      emit(CreateMeetingSuccess(msg));
    });
  }
}
