import '../data/models/response/employee_model.dart';
import '../data/models/response/meeting_model.dart';

abstract class MeetingsStates {}

class MeetingsInitial extends MeetingsStates {}

class MeetingsLoading extends MeetingsStates {}

class MeetingsSuccess extends MeetingsStates {
  final MeetingsResponse meetingsResponse;

  MeetingsSuccess(this.meetingsResponse);
}

class MeetingsError extends MeetingsStates {
  final String message;

  MeetingsError(this.message);
}

// Employees list
class EmployeesLoading extends MeetingsStates {}

class EmployeesSuccess extends MeetingsStates {
  final EmployeesResponse employeesResponse;

  EmployeesSuccess(this.employeesResponse);
}

class EmployeesError extends MeetingsStates {
  final String message;

  EmployeesError(this.message);
}

// Create meeting
class CreateMeetingLoading extends MeetingsStates {}

class CreateMeetingSuccess extends MeetingsStates {
  final String message;

  CreateMeetingSuccess(this.message);
}

class CreateMeetingError extends MeetingsStates {
  final String message;

  CreateMeetingError(this.message);
}
