import '../data/models/response/employee_model.dart';

abstract class NewsStates {}

class NewsInitial extends NewsStates {}

class NewsLoading extends NewsStates {}

class NewsSuccess extends NewsStates {
  final List<dynamic> articles;
  NewsSuccess(this.articles);
}

class NewsError extends NewsStates {
  final String message;
  NewsError(this.message);
}

// Create news states
class CreateNewsLoading extends NewsStates {}

class CreateNewsSuccess extends NewsStates {
  final String message;
  CreateNewsSuccess(this.message);
}

class CreateNewsError extends NewsStates {
  final String message;
  CreateNewsError(this.message);
}

// Employees states
class EmployeesLoading extends NewsStates {}

class EmployeesSuccess extends NewsStates {
  final EmployeesResponse employeesResponse;
  EmployeesSuccess(this.employeesResponse);
}

class EmployeesError extends NewsStates {
  final String message;
  EmployeesError(this.message);
}
