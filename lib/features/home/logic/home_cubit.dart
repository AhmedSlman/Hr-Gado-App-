import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/features/home/data/models/request/attendance_requset_model.dart';
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

    final request = AttendanceRequestModel(
      latitude: latitude,
      longitude: longitude,
    );

    final result = await repository.checkIn(request);

    result.fold((failure) {
      print('🔍 HomeCubit - CheckIn Failure: ${failure.message}');
      emit(AttendanceError(failure.message));
    }, (response) => emit(AttendanceSuccess(response)));
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
    }, (response) => emit(AttendanceSuccess(response)));
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
