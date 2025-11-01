import 'package:dartz/dartz.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import '../../../../../core/error/result_extensions.dart';
import '../../models/response/notifications_response.dart';
import '../../repository/endpoints.dart';

abstract class NotificationsRemoteDataSource {
  Future<Result<NotificationsResponse>> getNotifications();
  Future<Result<void>> markAsRead(String notificationId);
  Future<Result<void>> markAllAsRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  NotificationsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<NotificationsResponse>> getNotifications() async {
    try {
      final result = await _apiConsumer.get<NotificationsResponse>(
        path: NotificationsEndpoints.notifications,
        headers: {
          'Accept': 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json',
        },
        parser: (json) => NotificationsResponse.fromJson(json),
        showLoading: false,
      );

      return result.fold(
        onSuccess: (data) => Right(data),
        onFailure: (failure) => Left(failure),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'فشل في تحميل الإشعارات: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      final result = await _apiConsumer.put<void>(
        path: NotificationsEndpoints.markAsRead(notificationId),
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
          message: 'فشل في تحديث حالة الإشعار: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      final result = await _apiConsumer.put<void>(
        path: NotificationsEndpoints.markAllAsRead,
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
          message: 'فشل في تحديث حالة جميع الإشعارات: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}

