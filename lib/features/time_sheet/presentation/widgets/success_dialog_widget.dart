import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class SuccessDialogWidget extends StatelessWidget {
  final String title;
  final String message;

  const SuccessDialogWidget({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () => context.pop(),
              child: Icon(Icons.close, color: AppColors.primary),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppAssets.svg(IconsAssets.correctIcon),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppStyles.s18Medium.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: AppStyles.s14.copyWith(color: AppColors.greyIcon),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
