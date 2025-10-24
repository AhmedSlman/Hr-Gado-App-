import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/request/login_request.dart';
import '../data/repository/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    final request = LoginRequest(username: username, password: password);
    final result = await repository.login(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> forgotPassword(String username) async {
    emit(AuthLoading());

    final result = await repository.forgotPassword(username);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthForgotPasswordSuccess()),
    );
  }
}
