import 'package:hr_app/features/vacation/data/models/response/advance_list_response.dart';
import 'package:hr_app/features/vacation/data/models/response/vacation_list_response.dart';

abstract class VacationStates {}

class VacationInitial extends VacationStates {}

class VacationSubmitting extends VacationStates {}

class VacationSubmitSuccess extends VacationStates {
  final String message;
  VacationSubmitSuccess(this.message);
}

class VacationSubmitError extends VacationStates {
  final String message;
  VacationSubmitError(this.message);
}

class VacationLoading extends VacationStates {}

class VacationLoadError extends VacationStates {
  final String message;
  VacationLoadError(this.message);
}

class VacationLoadSuccess extends VacationStates {
  final VacationListResponse response; // VacationListResponse
  VacationLoadSuccess(this.response);
}

class AdvanceLoading extends VacationStates {}

class AdvanceLoadError extends VacationStates {
  final String message;
  AdvanceLoadError(this.message);
}

class AdvanceLoadSuccess extends VacationStates {
  final AdvanceListResponse response;
  AdvanceLoadSuccess(this.response);
}
