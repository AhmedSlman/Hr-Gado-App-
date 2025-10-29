import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';

class NetMonthlySalary extends StatelessWidget {
  final SalarySummaryData salaryData;

  const NetMonthlySalary({super.key, required this.salaryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "صافي الراتب الشهري",
              style: AppStyles.s16Light.copyWith(color: AppColors.primary),
            ),

            Text(
              salaryData.netMonthlySalary.toString(),
              style: AppStyles.s32Medium.copyWith(color: AppColors.primary),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Bottom Indicators Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Total Bonuses (Green)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: " إجمالي الحوافز:  ",
                    style: AppStyles.s12Medium.copyWith(color: Colors.black),
                  ),
                  TextSpan(
                    text: salaryData.totalBonuses.toString(),
                    style: AppStyles.s14Medium.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),

            // Right: Total Deductions (Red)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "إجمالي الحسومات:  ",
                    style: AppStyles.s12Medium.copyWith(color: Colors.black),
                  ),
                  TextSpan(
                    text: salaryData.totalDeductions.toString(),
                    style: AppStyles.s14Medium.copyWith(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
