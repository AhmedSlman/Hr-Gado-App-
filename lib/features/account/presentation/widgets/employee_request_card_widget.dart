import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class EmployeeRequestCardWidget extends StatelessWidget {
  final String employeeName;
  final String date;
  final String requestType; // 'طلب اجازة' or 'طلب سلفة'
  final String details; // '4 ايام' or '1000 ج'
  final VoidCallback? onTap;

  const EmployeeRequestCardWidget({
    super.key,
    required this.employeeName,
    required this.date,
    required this.requestType,
    required this.details,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),

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
          children: [
            // Blue bar on the right
            Container(
              width: 4.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            SizedBox(width: 16.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      employeeName,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(width: 60.w),
                    Text(
                      requestType,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(width: 60.w),
                    Text(
                      details,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
