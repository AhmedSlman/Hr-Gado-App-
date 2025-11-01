import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/notifications/data/models/response/notification_model.dart';

class NotificationCardWidget extends StatelessWidget {
  static Color _getTypeColor(String type) {
    switch (type) {
      case 'advance_approval':
      case 'leave_approval':
      case 'request_approval':
        return Colors.green;
      case 'advance_rejected':
      case 'leave_rejected':
      case 'request_rejected':
        return Colors.red;
      case 'deduction':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  static String _getTypeLabel(String type) {
    switch (type) {
      case 'advance_approval':
        return 'موافقة سلفة';
      case 'advance_rejected':
        return 'رفض سلفة';
      case 'leave_approval':
        return 'موافقة إجازة';
      case 'leave_rejected':
        return 'رفض إجازة';
      case 'request_approval':
        return 'موافقة طلب';
      case 'request_rejected':
        return 'رفض طلب';
      case 'deduction':
        return 'خصم';
      default:
        return 'إشعار';
    }
  }
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.fillGrey
                    : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: notification.isRead
                    ? AppColors.grayText
                    : AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Type Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getTypeLabel(notification.type),
                      style: AppStyles.s12.copyWith(
                        color: _getTypeColor(notification.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.message,
                    style: AppStyles.s14.copyWith(
                      color: notification.isRead
                          ? AppColors.grayText
                          : AppColors.black,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.date,
                    style: AppStyles.s12.copyWith(
                      color: AppColors.greyIcon,
                    ),
                  ),
                ],
              ),
            ),
            // Unread Indicator
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

