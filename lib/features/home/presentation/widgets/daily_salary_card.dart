import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/home/data/models/response/home_screen_model.dart';

class DailySalaryCard extends StatelessWidget {
  final DailySalaryData dailySalary;
  final String date;

  const DailySalaryCard({
    super.key,
    required this.dailySalary,
    required this.date,
  });

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
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: AppStyles.s12.copyWith(color: AppColors.black),
                  ),
                ],
              ),

              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dailySalary.baseDailySalary}',
                    style: AppStyles.s20Bold.copyWith(color: AppColors.black),
                  ),

                  Text(
                    'حافز (${dailySalary.bonus})',
                    style: AppStyles.s14Medium.copyWith(color: Colors.green),
                  ),
                  Text(
                    '${dailySalary.netAmount}',
                    style: AppStyles.s16Medium.copyWith(color: Colors.green),
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
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
