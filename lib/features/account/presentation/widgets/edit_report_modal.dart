import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

enum EditReportType {
  devicesAndMeters, // عدد الأجهزة والأمتار
  achievedGoals, // الأهداف المحققة
}

class EditReportModal extends StatelessWidget {
  final EditReportType editType;

  const EditReportModal({super.key, required this.editType});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'تعديل التقرير',
                    textAlign: TextAlign.center,
                    style: AppStyles.s18Bold.copyWith(color: AppColors.black),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.grayText,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Content based on edit type
            _buildContent(context),
            SizedBox(height: 24.h),
            // Send button
            CustomButton(
              text: 'ارسال',
              onPressed: () {
                // Handle send
                Navigator.of(context).pop();
              },
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (editType) {
      case EditReportType.devicesAndMeters:
        return _buildDevicesAndMetersContent();
      case EditReportType.achievedGoals:
        return _buildAchievedGoalsContent();
    }
  }

  Widget _buildDevicesAndMetersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number of devices field
        Text(
          'عدد الاجهزة',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'اختر عدد الأجهزة',
                  style: AppStyles.s16.copyWith(color: AppColors.grayText),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Number of meters field
        Text(
          'عدد الامتار',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'اختر عدد الامتار',
                  style: AppStyles.s16.copyWith(color: AppColors.grayText),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievedGoalsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Achieved goals label
        Text(
          'الأهداف المحققة 2',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        // Text input field
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '',
              hintStyle: AppStyles.s16.copyWith(color: AppColors.grayText),
            ),
            style: AppStyles.s16.copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
