import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/features/home/data/models/response/home_screen_model.dart';

class MeetingCard extends StatelessWidget {
  final MeetingData meeting;

  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      // height: 40.h,
      margin: EdgeInsets.only(left: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 24.h, width: 2.w, color: AppColors.deepGreenColor),
          SizedBox(width: 8.w),
          // Google Meet icon
          AppAssets.svg(AppAssets.googleMeet, width: 24.w, height: 24.h),
          SizedBox(width: 8.w),
          // Text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                meeting.title,
                style: AppStyles.s14Medium.copyWith(color: AppColors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4.h),
              Text(
                meeting.time,
                style: AppStyles.s12.copyWith(color: AppColors.grayText),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
