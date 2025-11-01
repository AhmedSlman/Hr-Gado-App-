import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/data/models/employee_request_type.dart';
import 'package:hr_app/features/account/presentation/components/long_term_advance_request_section.dart';
import 'package:hr_app/features/account/presentation/components/normal_advance_request_section.dart';
import 'package:hr_app/features/account/presentation/components/vacation_request_section.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/requset_actions_buttons.dart';

class EmployeeRequestSection extends StatelessWidget {
  final EmployeeRequestType requestType;

  const EmployeeRequestSection({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        // Profile picture
        const ProfilePictureWidget(imageUrl: ''),
        SizedBox(height: 12.h),
        // Employee name
        Text(
          'طارق على',
          style: AppStyles.s18Bold.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 4.h),
        // Job title
        Text(
          'خدمة عملاء',
          style: AppStyles.s14.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 32.h),
        // Content based on request type
        _buildRequestContent(context),
        SizedBox(height: 32.h),
        // Action buttons
        RequsetActionsButtons(onAcceptPressed: () {}, onRejectPressed: () {}),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildRequestContent(BuildContext context) {
    switch (requestType) {
      case EmployeeRequestType.vacation:
        return const VacationRequestSection();
      case EmployeeRequestType.normalAdvance:
        return const NormalAdvanceRequestSection();
      case EmployeeRequestType.longTermAdvance:
        return const LongTermAdvanceRequestSection();
    }
  }
}
