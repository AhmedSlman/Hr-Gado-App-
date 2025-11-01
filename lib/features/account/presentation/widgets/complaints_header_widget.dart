import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ComlaintsHeaderWidget extends StatelessWidget {
  const ComlaintsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        'نحن هنا للاستماع إليك! إذا كان لديك أي شكوى أو اقتراح، لا تتردد في مشاركتنا لتحسين تجربتك.',
        textAlign: TextAlign.center,
        style: AppStyles.s14.copyWith(color: AppColors.black),
      ),
    );
  }
}
