import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

import '../../data/models/response/deduction_model.dart';

class DeductionCard extends StatelessWidget {
  final DeductionModel deduction;

  const DeductionCard({super.key, required this.deduction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التاريخ في الأعلى على اليمين
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    deduction.date,
                    style: AppStyles.s12.copyWith(color: AppColors.grayText),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // اسم الموظف والوظيفة (للمدير فقط)
              if (deduction.employee != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        deduction.employee!.name,
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        deduction.employee!.job,
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${deduction.amount}',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.redBoldColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      deduction.type,
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.secondary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
