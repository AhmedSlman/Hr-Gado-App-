import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_balance_item_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_request_field_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';

class EmployeeRequsetDetailsView extends StatelessWidget {
  const EmployeeRequsetDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    // Profile picture
                    const ProfilePictureWidget(),
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
                    // Leave balance section
                    LeaveBalanceItemWidget(
                      label: 'عدد ايام الاجازات',
                      value: '21 يوم',
                    ),
                    LeaveBalanceItemWidget(
                      label: 'عدد ايام الاجازة المستهلكة',
                      value: '9 ايام',
                    ),
                    LeaveBalanceItemWidget(
                      label: 'عدد ايام الاجازة المتبقية',
                      value: '12 يوم',
                      isRemaining: true,
                      showDivider: false,
                    ),
                    SizedBox(height: 24.h),
                    // Leave request details section
                    LeaveRequestFieldWidget(
                      label: 'تاريخ بداية الاجازة',
                      value: '8 يناير 2025',
                      onTap: () {
                        // Handle date picker
                      },
                    ),
                    LeaveRequestFieldWidget(
                      label: 'تاريخ نهاية الاجازة',
                      value: '15 يناير 2025',
                      onTap: () {
                        // Handle date picker
                      },
                    ),
                    LeaveRequestFieldWidget(
                      label: 'عدد الايام المطلوبة',
                      value: '3',
                      isDaysField: true,
                    ),
                    SizedBox(height: 32.h),
                    // Action buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          // Reject button (red)
                          Expanded(
                            child: CustomButton(
                              text: 'رفض الطلب',
                              backgroundColor: Colors.red,
                              height: 50.h,
                              onPressed: () {
                                // Handle reject
                              },
                              textStyle: AppStyles.s16Medium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Accept button (green)
                          Expanded(
                            child: CustomButton(
                              text: 'قبول الطلب',
                              backgroundColor: AppColors.deepGreenColor,
                              height: 50.h,
                              onPressed: () {
                                // Handle accept
                              },
                              textStyle: AppStyles.s16Medium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
