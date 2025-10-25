import '../data/models/response/attendance_model.dart';
import '../data/models/response/home_screen_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

// Attendance States
class AttendanceLoading extends HomeStates {}

class AttendanceSuccess extends HomeStates {
  final AttendanceResponseModel response;
  AttendanceSuccess(this.response);
}

class AttendanceError extends HomeStates {
  final String message;
  AttendanceError(this.message);
}

// Home Screen States
class HomeScreenLoading extends HomeStates {}

class HomeScreenSuccess extends HomeStates {
  final HomeScreenModel homeScreen;
  HomeScreenSuccess(this.homeScreen);
}

class HomeScreenError extends HomeStates {
  final String message;
  HomeScreenError(this.message);
}
