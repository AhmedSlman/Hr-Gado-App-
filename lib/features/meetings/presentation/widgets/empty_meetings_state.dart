import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class EmptyMeetingsState extends StatelessWidget {
  const EmptyMeetingsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 120.h),

          // Empty Meeting Image
          Image.asset(
            AppAssets.emptyMeeting,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 24.h),

          // Empty State Text
          Text(
            "لم يتم تحديد أي اجتماعات حتى الآن.سيتم إشعارك عند إضافة أي اجتماعات جديدة!",
            style: AppStyles.s16Medium.copyWith(
              color: AppColors.secondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
