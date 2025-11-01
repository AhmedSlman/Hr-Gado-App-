import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class LeaveRequestFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isDaysField;
  final bool isAmountField; // For currency icon
  final VoidCallback? onTap;

  const LeaveRequestFieldWidget({
    super.key,
    required this.label,
    required this.value,
    this.isDaysField = false,
    this.isAmountField = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 8.h),
          // Input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: isDaysField ? AppColors.lightGrey : AppColors.lightBlue,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                if (!isDaysField && !isAmountField) ...[
                  Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                ],
                if (isAmountField) ...[
                  Icon(
                    Icons.attach_money,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  value,
                  style: AppStyles.s16.copyWith(color: AppColors.black),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
