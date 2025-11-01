import 'package:dartz/dartz.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import '../data_source/remote/remote_data_source.dart';
import '../models/response/notifications_response.dart';
import 'notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<NotificationsResponse>> getNotifications() async {
    try {
      return await remoteDataSource.getNotifications();
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
      return await remoteDataSource.markAsRead(notificationId);
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
      return await remoteDataSource.markAllAsRead();
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

