import 'package:dartz/dartz.dart';
import 'package:hr_app/features/auth/data/repository/auth_repository_impl.dart'
    as remoteDataSource;

import '../data_source/local/auth_local_data_source.dart';
import '../data_source/remote/auth_remote_data_source.dart';
import '../models/request/login_request.dart';
import '../models/response/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result_extensions.dart';
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

      return result.fold((failure) => Left(failure), (user) async {
        await localDataSource.saveUser(user);
        return Right(user);
      });
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to login: ${e.toString()}',
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
}
