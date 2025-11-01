import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/notifications/logic/notifications_cubit.dart';
import 'package:hr_app/features/notifications/logic/notifications_states.dart';
import 'package:hr_app/features/notifications/presentation/components/notifications_list_section.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final hasUnread = state is NotificationsLoadSuccess &&
            state.response.notifications.any((n) => !n.isRead);

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: const CustomAppBar(title: "الإشعارات"),
                      ),
                    ),
                    // Mark All as Read Button
                    if (hasUnread)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: TextButton(
                          onPressed: () {
                            NotificationsCubit.get(context).markAllAsRead();
                          },
                          child: Text(
                            'تحديد الكل كمقروء',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const NotificationsListSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
