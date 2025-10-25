import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SuccessDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // علامة X
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.close, color: AppColors.grayText, size: 24),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssets.svg(IconsAssets.correctIcon),
                SizedBox(width: 6.w),
                Text(
                  'تم إرسال التقرير بنجاح',
                  style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              "تم ارسال تقريرك اليومي، وسيتم مراجعته من قبل الإدارة, يمكنك الآن تسجيل موعد الانصراف. نقدر جهودك ونتمنى لك دوام التوفيق.",
              textAlign: TextAlign.center,
              style: AppStyles.s14Medium.copyWith(color: AppColors.grayText),
            ),

            const SizedBox(height: 20),

            CustomButton(text: 'تسجيل الانصراف', onPressed: onConfirm),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
