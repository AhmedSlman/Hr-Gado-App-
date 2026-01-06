import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';
import 'package:hr_app/features/home/data/models/request/daily_report_request_model.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import '../data/repository/home_repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository repository;
  HomeCubit(this.repository) : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> loadItems() async {
    // result.fold(
    //   (failure) => emit(HomeError(failure.message)),
    //   (items) => emit(HomeSuccess(items)),
    // );
  }

  Future<void> checkIn(double latitude, double longitude) async {
    emit(AttendanceLoading());
print('🔍 HomeCubit - CheckIn: $latitude, $longitude');
    final request = AttendanceRequestModel(
      latitude: latitude,
      longitude: longitude,
    );
    

    final result = await repository.checkIn(request);

    result.fold((failure) {
      print('🔍 HomeCubit - CheckIn Failure: ${failure.message}');
      emit(AttendanceError(failure.message));
    }, (response) {
      print('🔍 HomeCubit - CheckIn Success');
      print('🔍 Response key: ${response.key}');
      print('🔍 Response msg: ${response.msg}');
      print('🔍 isSuccess: ${response.isSuccess}');
      emit(AttendanceSuccess(response));
    });
  }

  Future<void> checkOut(double latitude, double longitude) async {
    emit(AttendanceLoading());

    final request = AttendanceRequestModel(
      latitude: latitude,
      longitude: longitude,
    );

    final result = await repository.checkOut(request);

    result.fold((failure) {
      print('🔍 HomeCubit - CheckOut Failure: ${failure.message}');
      emit(AttendanceError(failure.message));
    }, (response) {
      print('🔍 HomeCubit - CheckOut Success');
      print('🔍 Response key: ${response.key}');
      print('🔍 Response msg: ${response.msg}');
      print('🔍 isSuccess: ${response.isSuccess}');
      emit(AttendanceSuccess(response));
    });
  }

  Future<void> submitDailyReport(WorkReportModel workReport) async {
    emit(DailyReportLoading());

    final request = DailyReportRequestModel(
      workReport: workReport,
    );

    final result = await repository.submitDailyReport(request);

    result.fold((failure) {
      print('🔍 HomeCubit - DailyReport Failure: ${failure.message}');
      emit(DailyReportError(failure.message));
    }, (response) => emit(DailyReportSuccess(response)));
  }

  Future<void> getHomeScreen() async {
    emit(HomeScreenLoading());

    final result = await repository.getHomeScreen();

    result.fold((failure) {
      print('🔍 HomeCubit - HomeScreen Failure: ${failure.message}');
      emit(HomeScreenError(failure.message));
    }, (homeScreen) => emit(HomeScreenSuccess(homeScreen)));
  }
}
