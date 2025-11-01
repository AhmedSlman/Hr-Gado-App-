import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/response/notifications_response.dart';
import '../data/repository/notifications_repository.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepository repository;
  final Set<String> _readNotificationIds = <String>{};

  NotificationsCubit(this.repository) : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);

  Future<void> getNotifications() async {
    emit(NotificationsLoading());

    final result = await repository.getNotifications();

    result.fold(
      (failure) => emit(NotificationsLoadError(failure.message)),
      (response) {
        // Update notifications with read status from local tracking
        final updatedNotifications = response.notifications.map((notification) {
          return notification.copyWith(
            isRead: _readNotificationIds.contains(notification.id),
          );
        }).toList();

        final updatedResponse = NotificationsResponse(
          key: response.key,
          msg: response.msg,
          notifications: updatedNotifications,
        );

        emit(NotificationsLoadSuccess(updatedResponse));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    emit(MarkAsReadLoading());

    final result = await repository.markAsRead(notificationId);

    result.fold(
      (failure) => emit(MarkAsReadError(failure.message)),
      (_) {
        // Mark as read locally
        _readNotificationIds.add(notificationId);
        emit(MarkAsReadSuccess(notificationId));
        // Reload notifications after marking as read
        getNotifications();
      },
    );
  }

  Future<void> markAllAsRead() async {
    emit(MarkAllAsReadLoading());

    final result = await repository.markAllAsRead();

    result.fold(
      (failure) => emit(MarkAllAsReadError(failure.message)),
      (_) {
        // Mark all as read locally
        if (state is NotificationsLoadSuccess) {
          final currentState = state as NotificationsLoadSuccess;
          _readNotificationIds.addAll(
            currentState.response.notifications.map((n) => n.id),
          );
        }
        emit(MarkAllAsReadSuccess());
        // Reload notifications after marking all as read
        getNotifications();
      },
    );
  }
}

