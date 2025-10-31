import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/vacation_constants.dart';

class NormalVacationWidget extends StatelessWidget {
  const NormalVacationWidget({
    super.key,
    required this.totalDays,
    required this.consumedDays,
    required this.remainingDays,
  });

  final int totalDays;
  final int consumedDays;
  final int remainingDays;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: VacationConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                VacationConstants.totalDaysLabel,
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
              Text(
                "$totalDays يوم",
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                VacationConstants.consumedDaysLabel,
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
              Text(
                "$consumedDays ايام",
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.lightBlue),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                VacationConstants.remainingDaysLabel,
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
              Text(
                "$remainingDays يوم",
                style: AppStyles.s32Medium.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
