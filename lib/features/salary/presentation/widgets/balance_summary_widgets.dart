import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';

class BalanceSummaryWidgets extends StatelessWidget {
  final SalarySummaryData salaryData;

  const BalanceSummaryWidgets({super.key, required this.salaryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "تاريخ استلام الراتب",
              style: AppStyles.s14.copyWith(color: AppColors.primary),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 4),
            Text(
              salaryData.salaryReceiptDate,
              style: AppStyles.s16Medium.copyWith(color: AppColors.secondary),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "الراتب اليومي",
              style: AppStyles.s14.copyWith(color: AppColors.primary),
              textAlign: TextAlign.right,
            ),
            Text(
              salaryData.dailySalary.toString(),
              style: AppStyles.s16Medium.copyWith(color: AppColors.secondary),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "الراتب الشهري الأساسي",
              style: AppStyles.s14.copyWith(color: AppColors.primary),
              textAlign: TextAlign.right,
            ),
            Text(
              salaryData.baseSalary.toString(),
              style: AppStyles.s16Medium.copyWith(color: AppColors.secondary),
            ),
          ],
        ),
      ],
    );
  }
}
