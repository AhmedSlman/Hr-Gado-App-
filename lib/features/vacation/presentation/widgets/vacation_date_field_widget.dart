import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/vacation_constants.dart';

class VacationDateFieldWidget extends StatelessWidget {
  const VacationDateFieldWidget({
    super.key,
    required this.label,
    required this.dateText,
    required this.onTap,
  });

  final String label;
  final String dateText; // already formatted text passed from parent
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: VacationConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              label,
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary, width: 1.5),
                color: AppColors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    dateText,
                    textAlign: TextAlign.right,
                    style: AppStyles.s16Light,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
