import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class LeaveBalanceItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isRemaining; // Special styling for remaining days
  final bool showDivider;

  const LeaveBalanceItemWidget({
    super.key,
    required this.label,
    required this.value,
    this.isRemaining = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Value on the left (RTL)
              Text(
                value,
                style: isRemaining
                    ? AppStyles.s18Bold.copyWith(color: AppColors.primary)
                    : AppStyles.s16.copyWith(color: AppColors.black),
              ),
              const Spacer(),
              // Label on the right (RTL)
              Text(
                label,
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: AppColors.lightGrey,
            height: 1,
            thickness: 1,
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
