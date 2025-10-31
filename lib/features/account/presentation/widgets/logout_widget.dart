import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle logout
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(Icons.logout, color: AppColors.primary, size: 24.sp),
            SizedBox(width: 12.w),

            Text(
              'تسجيل خروج',
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
