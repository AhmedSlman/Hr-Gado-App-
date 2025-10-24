import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/utils/user_helper.dart';
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

  // Logout method
  Future<void> logout() async {
    await repository.logout();
    emit(AuthInitial());
    // إعادة توجيه إلى صفحة تسجيل الدخول
    // سيتم التعامل مع إعادة التوجيه في الـ router redirect
  }

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    await UserHelper.refreshUser();
    if (UserHelper.isLoggedIn) {
      final user = UserHelper.currentUser;
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }
}
