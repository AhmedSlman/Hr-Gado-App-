import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AccountMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showDivider;

  const AccountMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: AppColors.lightBlue,
            height: 1,
            thickness: 1,
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
