import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class DateWorkHoursWidget extends StatelessWidget {
  const DateWorkHoursWidget({
    super.key,
    required this.date,
    required this.workHours,
  });
  final String date;
  final String workHours;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: AppStyles.s12Medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "عدد ساعات العمل",
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
            Text(
              workHours,
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }
}
