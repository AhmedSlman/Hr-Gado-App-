import '../data/models/response/notifications_response.dart';

abstract class NotificationsStates {}

class NotificationsInitial extends NotificationsStates {}

class NotificationsLoading extends NotificationsStates {}

class NotificationsLoadSuccess extends NotificationsStates {
  final NotificationsResponse response;
  NotificationsLoadSuccess(this.response);
}

class NotificationsLoadError extends NotificationsStates {
  final String message;
  NotificationsLoadError(this.message);
}

class MarkAsReadLoading extends NotificationsStates {}

class MarkAsReadSuccess extends NotificationsStates {
  final String notificationId;
  MarkAsReadSuccess(this.notificationId);
}

class MarkAsReadError extends NotificationsStates {
  final String message;
  MarkAsReadError(this.message);
}

class MarkAllAsReadLoading extends NotificationsStates {}

class MarkAllAsReadSuccess extends NotificationsStates {}

class MarkAllAsReadError extends NotificationsStates {
  final String message;
  MarkAllAsReadError(this.message);
}

