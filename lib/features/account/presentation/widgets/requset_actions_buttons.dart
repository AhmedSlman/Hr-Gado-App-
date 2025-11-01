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
    this.isApproving = false,
    this.isRejecting = false,
  });
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onRejectPressed;
  final bool isApproving;
  final bool isRejecting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Accept button (green)
          Expanded(
            child: CustomButton(
              text: 'قبول الطلب',
              backgroundColor: AppColors.deepGreenColor,
              height: 50.h,
              onPressed: (isApproving || isRejecting) ? null : onAcceptPressed,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.white),
              isLoading: isApproving,
            ),
          ),
          SizedBox(width: 16.w),
          // Reject button (red)
          Expanded(
            child: CustomButton(
              text: 'رفض الطلب',
              backgroundColor: AppColors.red,
              height: 50.h,
              onPressed: (isApproving || isRejecting) ? null : onRejectPressed,
              textStyle: AppStyles.s16Medium.copyWith(color: AppColors.white),
              isLoading: isRejecting,
            ),
          ),
        ],
      ),
    );
  }
}
