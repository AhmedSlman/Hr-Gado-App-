import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class ForgetPassDialog extends StatelessWidget {
  final VoidCallback? onClose;

  const ForgetPassDialog({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button (X) in top right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,

                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Success icon and title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssets.svg(
                  IconsAssets.correctIcon,
                  height: 26.h,
                  width: 26.h,
                ),
                SizedBox(width: 12.w),
                Text(
                  "تم إرسال الطلب بنجاح",
                  style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Description text
            Text(
              "تم إرسال طلب تغيير كلمة المرور الخاصة بك بنجاح. يرجى الانتظار حتى تقوم الإدارة بمراجعة طلبك، وسيتم إعلامك بكلمة المرور الجديدة.",
              style: AppStyles.s14.copyWith(
                color: AppColors.grayText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // OK button
          ],
        ),
      ),
    );
  }

  static void show({required BuildContext context, VoidCallback? onClose}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ForgetPassDialog(onClose: onClose),
    );
  }
}
