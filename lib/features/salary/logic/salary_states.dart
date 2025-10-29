import '../data/models/response/salary_model.dart';

abstract class SalaryStates {}

class SalaryInitial extends SalaryStates {}

class SalaryLoading extends SalaryStates {}

class SalarySuccess extends SalaryStates {
  final SalarySummaryResponse salarySummary;

  SalarySuccess(this.salarySummary);
}

class SalaryError extends SalaryStates {
  final String message;

  SalaryError(this.message);
}
