import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class RequsetActionsButtons extends StatelessWidget {
  const RequsetActionsButtons({
    super.key,
    required this.onAcceptPressed,
    required this.onRejectPressed,
  });
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onRejectPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Reject button (red)
          Expanded(
            child: CustomButton(
              text: 'قبول الطلب',
              backgroundColor: AppColors.deepGreenColor,
              height: 50.h,
              onPressed: onAcceptPressed,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.white),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomButton(
              text: 'رفض الطلب',
              backgroundColor: AppColors.red,
              height: 50.h,
              onPressed: onRejectPressed,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.white),
            ),
          ),
          // Accept button (green)
        ],
      ),
    );
  }
}
