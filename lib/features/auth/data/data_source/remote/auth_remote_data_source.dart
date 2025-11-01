import 'package:dartz/dartz.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/network/api_consumer.dart';

import '../../../../../core/error/result_extensions.dart';

import '../../models/request/login_request.dart';
import '../../models/response/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<UserModel>> login(LoginRequest request);
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<UserModel>> login(LoginRequest request) async {
    try {
      final result = await _apiConsumer.post<UserModel>(
        path: '/employee/login',
        body: request.toJson(),
        parser: (json) => UserModel.fromJson(json['data']),
        showLoading: true,
        isFormData: true,
      );

      return result.fold(
        onSuccess: (data) => Right(data),
        onFailure: (failure) => Left(failure),
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
      final result = await _apiConsumer.post<void>(
        path: '/employee/forgot-password',
        body: {'username': username},
        showLoading: true,
        isFormData: true,
      );

      return result.fold(
        onSuccess: (_) => const Right(null),
        onFailure: (failure) => Left(failure),
      );
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
  Future<Result<void>> logout() async {
    try {
      final result = await _apiConsumer.post<void>(
        path: '/employee/logout',
        headers: {
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json',
        },
        showLoading: false,
      );

      return result.fold(
        onSuccess: (_) => const Right(null),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'فشل في تسجيل الخروج: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
