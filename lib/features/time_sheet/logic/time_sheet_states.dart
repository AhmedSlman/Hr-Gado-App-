import '../data/models/response/time_sheet_model.dart';

abstract class TimeSheetStates {}

class TimeSheetInitial extends TimeSheetStates {}

class TimeSheetLoading extends TimeSheetStates {}

class TimeSheetLoadSuccess extends TimeSheetStates {
  final List<TimeSheetModel> items;
  TimeSheetLoadSuccess(this.items);
}

class TimeSheetLoadError extends TimeSheetStates {
  final String message;
  TimeSheetLoadError(this.message);
}

class PermissionRequestProcessing extends TimeSheetStates {}

class PermissionRequestSuccess extends TimeSheetStates {
  final String message;
  PermissionRequestSuccess(this.message);
}

class PermissionRequestError extends TimeSheetStates {
  final String message;
  PermissionRequestError(this.message);
}

