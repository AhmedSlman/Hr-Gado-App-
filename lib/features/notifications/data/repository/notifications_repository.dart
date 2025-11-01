import '../../../../core/error/result_extensions.dart';
import '../models/response/notifications_response.dart';

abstract class NotificationsRepository {
  Future<Result<NotificationsResponse>> getNotifications();
  Future<Result<void>> markAsRead(String notificationId);
  Future<Result<void>> markAllAsRead();
}

