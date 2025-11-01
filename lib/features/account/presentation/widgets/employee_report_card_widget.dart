import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class EmployeeReportCardWidget extends StatelessWidget {
  final String date;
  final String employeeName;
  final String numberOfDevices;
  final String numberOfMeters;
  final VoidCallback? onTap;

  const EmployeeReportCardWidget({
    super.key,
    required this.date,
    required this.employeeName,
    required this.numberOfDevices,
    required this.numberOfMeters,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View details link - at the top
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'عرض تفاصيل التقرير',
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_back_ios,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Date and Employee name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and name column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      employeeName,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Blue divider
              Container(
                width: 1.w,
                height: 40.h,
                color: AppColors.lightBlue,
              ),
              SizedBox(width: 16.w),
              // Number of devices section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'عدد الاجهزة',
                      style: AppStyles.s14.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      numberOfDevices,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Blue divider
              Container(
                width: 1.w,
                height: 40.h,
                color: AppColors.lightBlue,
              ),
              SizedBox(width: 16.w),
              // Number of meters section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'عدد الامتار',
                      style: AppStyles.s14.copyWith(
                        color: AppColors.grayText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      numberOfMeters,
                      style: AppStyles.s16Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

