import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/empty_state_widget.dart';
import 'package:hr_app/features/notifications/logic/notifications_cubit.dart';
import 'package:hr_app/features/notifications/logic/notifications_states.dart';
import 'package:hr_app/features/notifications/presentation/widgets/notification_card_widget.dart';

class NotificationsListSection extends StatelessWidget {
  const NotificationsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsStates>(
      buildWhen: (previous, current) =>
          current is NotificationsLoading ||
          current is NotificationsLoadSuccess ||
          current is NotificationsLoadError,
      listener: (context, state) {
        if (state is NotificationsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        } else if (state is MarkAsReadError) {
          CustomSnackBar.showError(context, message: state.message);
        } else if (state is MarkAllAsReadError) {
          CustomSnackBar.showError(context, message: state.message);
        } else if (state is MarkAsReadSuccess) {
          CustomSnackBar.showSuccess(context, message: 'تم تحديث حالة الإشعار');
        } else if (state is MarkAllAsReadSuccess) {
          CustomSnackBar.showSuccess(
            context,
            message: 'تم تحديث حالة جميع الإشعارات',
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NotificationsLoadSuccess) {
          final notifications = state.response.notifications;

          if (notifications.isEmpty) {
            return Expanded(
              child: EmptyStateWidget.simple(
                message: 'لا توجد إشعارات',
                icon: Icons.notifications_none_outlined,
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationCardWidget(
                  notification: notification,
                  onTap: () {
                    // Mark as read when tapped (if not already read)
                    if (!notification.isRead) {
                      NotificationsCubit.get(context)
                          .markAsRead(notification.id);
                    }
                  },
                );
              },
            ),
          );
        }

        return Expanded(
          child: EmptyStateWidget.simple(
            message: 'لا توجد بيانات',
            icon: Icons.notifications_none_outlined,
          ),
        );
      },
    );
  }
}

