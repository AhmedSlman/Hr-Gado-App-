import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ReportDetailsWidget extends StatelessWidget {
  const ReportDetailsWidget({super.key, required this.report});
  final String report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'التقرير',
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Report text box
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
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
            child: Text(
              report,
              style: AppStyles.s14.copyWith(color: AppColors.black),
            ),
          ),
        ),
      ],
    );
  }
}
