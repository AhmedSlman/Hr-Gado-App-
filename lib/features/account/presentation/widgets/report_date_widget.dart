import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ReportDate extends StatelessWidget {
  final String? date;

  const ReportDate({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          date != null ? 'تقرير عمل $date' : 'تقرير عمل',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
