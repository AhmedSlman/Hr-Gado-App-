import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppAssets.image(
          ImagesAssets.gado,
          height: 100.h,
          width: 100.w,
          fit: BoxFit.contain,
        ),
        // SizedBox(height: 20.h),
        Text(
          title,
          style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
