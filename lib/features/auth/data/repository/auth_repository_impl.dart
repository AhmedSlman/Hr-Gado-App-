import 'package:dartz/dartz.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import '../data_source/local/auth_local_data_source.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../models/request/login_request.dart';
import '../models/response/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    try {
      final result = await remoteDataSource.login(request);

      return await result.fold(
        (failure) async {
          print('AuthRepository: Login failed - ${failure.message}');
          return Left(failure);
        },
        (user) async {
          print('AuthRepository: Login successful - User ID: ${user.id}');
          print('AuthRepository: User Role: ${user.role}');
          print('AuthRepository: User Job: ${user.job}');

          // Save user data to local cache
          await UserHelper.saveUser(user);
          print('AuthRepository: User data saved to UserHelper');

          await localDataSource.saveUser(user);
          print('AuthRepository: User data saved to local data source');

          return Right(user);
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'فشل في تسجيل الدخول: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword(String username) async {
    try {
      final result = await remoteDataSource.forgotPassword(username);
      return result;
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'فشل في إرسال رابط إعادة تعيين كلمة المرور: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    // Clear user data from local cache
    await UserHelper.clearUser();
    // Also clear from local data source if needed
    await localDataSource.clearUser();
  }
}
