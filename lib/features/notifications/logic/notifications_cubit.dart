import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/user_helper.dart';
import '../data/repository/notifications_repository.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepository repository;
  int _generation = 0;
  bool _loading = false;
  NotificationsCubit(this.repository) : super(NotificationsInitial());
  static NotificationsCubit get(context) => BlocProvider.of(context);

  void resetSession() {
    _generation++;
    _loading = false;
    emit(NotificationsInitial());
  }

  Future<void> getNotifications() async {
    if (_loading || !UserHelper.isLoggedIn) return;
    final generation = _generation, session = UserHelper.currentToken;
    _loading = true;
    if (state is! NotificationsLoadSuccess) emit(NotificationsLoading());
    try {
      final result = await repository.getNotifications();
      if (isClosed ||
          generation != _generation ||
          session != UserHelper.currentToken) {
        return;
      }
      result.fold(
        (failure) => emit(NotificationsLoadError(failure.message)),
        (response) => emit(NotificationsLoadSuccess(response)),
      );
    } finally {
      if (generation == _generation) _loading = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final generation = _generation, session = UserHelper.currentToken;
    final result = await repository.markAsRead(notificationId);
    if (isClosed ||
        generation != _generation ||
        session != UserHelper.currentToken) {
      return;
    }
    result.fold(
      (failure) => emit(MarkAsReadError(failure.message)),
      (_) => emit(MarkAsReadSuccess(notificationId)),
    );
    await getNotifications();
  }

  Future<void> markAllAsRead() async {
    final generation = _generation, session = UserHelper.currentToken;
    final result = await repository.markAllAsRead();
    if (isClosed ||
        generation != _generation ||
        session != UserHelper.currentToken) {
      return;
    }
    result.fold(
      (failure) => emit(MarkAllAsReadError(failure.message)),
      (_) => emit(MarkAllAsReadSuccess()),
    );
    await getNotifications();
  }

  Future<void> deleteNotification([String? id]) async {
    final generation = _generation, session = UserHelper.currentToken;
    final result = await repository.deleteNotification(id);
    if (isClosed ||
        generation != _generation ||
        session != UserHelper.currentToken) {
      return;
    }
    result.fold(
      (failure) => emit(NotificationsLoadError(failure.message)),
      (_) {},
    );
    await getNotifications();
  }
}
