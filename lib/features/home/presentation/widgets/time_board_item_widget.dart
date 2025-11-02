import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

/// حالة الانصراف
enum CheckOutStatus {
  notCheckedOut, // لم يتم تسجيل الانصراف
  onTime, // في الموعد
  early, // قبل الموعد
  late, // بعد الموعد
}

class TimeBoardWidget extends StatelessWidget {
  const TimeBoardWidget({
    super.key,
    required this.title,
    required this.time,
    required this.subtitle,
    this.isCompleted = false,
    this.checkOutStatus = CheckOutStatus.notCheckedOut,
    this.workEndTime = '',
  });

  final String title;
  final String time;
  final String subtitle;
  final bool isCompleted;
  final CheckOutStatus checkOutStatus;
  final String workEndTime;

  /// الحصول على لون الحدود حسب حالة الانصراف
  Color _getBorderColor() {
    switch (checkOutStatus) {
      case CheckOutStatus.notCheckedOut:
        return AppColors.primary;
      case CheckOutStatus.onTime:
        return Colors.green;
      case CheckOutStatus.early:
        return Colors.red;
      case CheckOutStatus.late:
        return Colors.orange;
    }
  }

  /// الحصول على اللون والنص حسب حالة الانصراف
  (Color color, String text) _getStatusInfo() {
    switch (checkOutStatus) {
      case CheckOutStatus.onTime:
        return (Colors.green, 'في الموعد');
      case CheckOutStatus.early:
        return (Colors.red, 'قبل الموعد');
      case CheckOutStatus.late:
        return (Colors.orange, 'بعد الموعد');
      case CheckOutStatus.notCheckedOut:
        return (AppColors.greyIcon, subtitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusText) = _getStatusInfo();
    final borderColor = _getBorderColor();
    final showStatus = checkOutStatus != CheckOutStatus.notCheckedOut;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: AppColors.greyIcon,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(title, style: AppStyles.s12Medium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              time,
              style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            showStatus
                ? Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusText,
                        style: AppStyles.s10Medium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Text(
                    subtitle,
                    style: AppStyles.s10Medium.copyWith(
                      color: AppColors.greyIcon,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
