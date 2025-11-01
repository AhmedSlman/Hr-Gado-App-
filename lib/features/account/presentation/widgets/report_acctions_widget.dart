import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ReportActionsWidget extends StatelessWidget {
  const ReportActionsWidget({
    super.key,
    required this.onEditPressed,
    required this.onConfirmPressed,
  });

  final VoidCallback? onEditPressed;
  final VoidCallback? onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'تعديل التقرير',
              backgroundColor: AppColors.white,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              height: 50.h,
              onPressed: onEditPressed,
              borderColor: AppColors.primary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomButton(
              text: 'تاكيد التقرير',
              backgroundColor: AppColors.primary,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.white),
              height: 50.h,
              onPressed: onConfirmPressed,
            ),
          ),
        ],
      ),
    );
  }
}
