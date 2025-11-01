import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';

class PersonDataWidget extends StatelessWidget {
  const PersonDataWidget({
    super.key,
    required this.employeeName,
    required this.jobTitle,
    required this.profileImageUrl,
  });
  final String employeeName;
  final String jobTitle;
  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePictureWidget(imageUrl: profileImageUrl),
        SizedBox(height: 12.h),
        // Employee name
        Text(
          employeeName,
          style: AppStyles.s18Bold.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 4.h),
        // Job title
        Text(jobTitle, style: AppStyles.s14.copyWith(color: AppColors.black)),
      ],
    );
  }
}
