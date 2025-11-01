import '../data/models/response/user_model.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}

class AuthForgotPasswordSuccess extends AuthStates {}

class AuthResetPasswordSuccess extends AuthStates {}

class AuthLogoutLoading extends AuthStates {}

class AuthLogoutSuccess extends AuthStates {
  final String message;
  AuthLogoutSuccess(this.message);
}

class AuthLogoutError extends AuthStates {
  final String message;
  AuthLogoutError(this.message);
}
