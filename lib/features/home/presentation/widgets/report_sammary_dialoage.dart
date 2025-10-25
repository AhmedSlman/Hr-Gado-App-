import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ReportSummaryDialog extends StatelessWidget {
  final String devices;
  final String meters;
  final String report;
  final VoidCallback onConfirm;

  const ReportSummaryDialog({
    super.key,
    required this.devices,
    required this.meters,
    required this.report,
    required this.onConfirm,
  });

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

            // العنوان
            Text(
              "الرجاء التاكد من ملأ البيانات بطريقة صحيحة قبل الارسال حتى لا يتم تطبيق اللوائح فى حالة التلاعب",
              style: AppStyles.s16Light,
              textAlign: TextAlign.center,
            ),
            Divider(color: AppColors.primary),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "عدد الاجهزه: ",
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: devices,
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "عدد الامتار: ",
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: meters,
                        style: AppStyles.s14Medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                "تقرير العمل :",
                style: AppStyles.s14Medium.copyWith(color: AppColors.black),
              ),
            ),
            SizedBox(height: 6.h),

            Text(
              report,
              style: AppStyles.s12Medium.copyWith(color: AppColors.grayText),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            CustomButton(text: 'تأكيد', onPressed: onConfirm),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
