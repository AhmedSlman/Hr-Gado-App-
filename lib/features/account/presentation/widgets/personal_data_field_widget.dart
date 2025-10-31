import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class PersonalDataFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const PersonalDataFieldWidget({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 8.h),

          Text(value, style: AppStyles.s16.copyWith(color: AppColors.black)),

          // Label on the right (RTL)
          SizedBox(height: 12.h),
          if (showDivider)
            Divider(color: AppColors.lightBlue, height: 1, thickness: 1),
        ],
      ),
    );
  }
}
