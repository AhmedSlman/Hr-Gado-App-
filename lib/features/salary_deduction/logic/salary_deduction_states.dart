import '../data/models/response/deduction_model.dart';
import '../data/models/response/employee_model.dart';

abstract class SalaryDeductionStates {}

class SalaryDeductionInitial extends SalaryDeductionStates {}

class SalaryDeductionLoading extends SalaryDeductionStates {}

class SalaryDeductionSuccess extends SalaryDeductionStates {
  final DeductionsResponse deductionsResponse;
  SalaryDeductionSuccess(this.deductionsResponse);
}

class SalaryDeductionError extends SalaryDeductionStates {
  final String message;
  SalaryDeductionError(this.message);
}

// Employees states
class EmployeesLoading extends SalaryDeductionStates {}

class EmployeesSuccess extends SalaryDeductionStates {
  final EmployeesResponse employeesResponse;
  EmployeesSuccess(this.employeesResponse);
}

class EmployeesError extends SalaryDeductionStates {
  final String message;
  EmployeesError(this.message);
}

// Create deduction states
class CreateDeductionLoading extends SalaryDeductionStates {}

class CreateDeductionSuccess extends SalaryDeductionStates {
  final String message;
  CreateDeductionSuccess(this.message);
}

class CreateDeductionError extends SalaryDeductionStates {
  final String message;
  CreateDeductionError(this.message);
}
