import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_request_field_widget.dart';

class LongTermAdvanceRequestSection extends StatelessWidget {
  const LongTermAdvanceRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Advance type
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Text(
                'نوع السلفة',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              Text(
                'سلفة طويلة الامد',
                style: AppStyles.s16.copyWith(color: AppColors.black),
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.lightBlue,
          height: 1,
          thickness: 1,
          indent: 16.w,
          endIndent: 16.w,
        ),
        SizedBox(height: 24.h),
        // Advance request fields
        LeaveRequestFieldWidget(
          label: 'المبلغ المطلوب للسلفة',
          value: '3000',
          isAmountField: true,
        ),
        LeaveRequestFieldWidget(label: 'الوقت المطلوب للسداد', value: '5 اشهر'),
      ],
    );
  }
}
