import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class LeaveRequestFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isDaysField; // Special styling for days field (gray border)
  final VoidCallback? onTap;

  const LeaveRequestFieldWidget({
    super.key,
    required this.label,
    required this.value,
    this.isDaysField = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label on the right (RTL)
          Row(
            children: [
              const Spacer(),
              Text(
                label,
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Input field
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: isDaysField
                      ? AppColors.lightGrey
                      : AppColors.lightBlue,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    value,
                    style: AppStyles.s16.copyWith(color: AppColors.black),
                  ),
                  if (!isDaysField) ...[
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.lightBlue,
                      size: 20.sp,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
