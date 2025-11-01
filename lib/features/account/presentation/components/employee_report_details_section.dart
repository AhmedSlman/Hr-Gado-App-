import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/presentation/widgets/person_data_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_acctions_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_date_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_details_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_row_card_widget.dart';

class EmployeeReportDetailsSection extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onConfirmPressed;

  const EmployeeReportDetailsSection({
    super.key,
    this.onEditPressed,
    this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24.h),
          PersonDataWidget(
            employeeName: 'طارق على',
            jobTitle: 'خدمة عملاء',
            profileImageUrl: '',
          ),
          SizedBox(height: 32.h),
          ReportDate(),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                ReportRowCardWidget(title: 'عدد الامتار', value: '2'),
                SizedBox(height: 12.h),
                ReportRowCardWidget(title: 'عدد الساعات', value: '8'),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Report label
          ReportDetailsWidget(
            report:
                'لوريم إيبسوم هو ببساطة نص وهمي من صناعة الطباعة والتنضيد. كان لوريم إيبسوم هو النص الوهمي القياسي في الصناعة منذ القرن الخامس عشر الميلادي، عندما أخذت طابعة غير معروفة لوحًا من النوع وقامت بخلطه لعمل كتاب عينة. لقد نجت ليس فقط خمسة قرون، بل وأيضًا القفزة إلى التنضيد الإلكتروني، وظلت دون تغيير أساسي.',
          ),
          SizedBox(height: 32.h),
          ReportActionsWidget(
            onEditPressed: onEditPressed,
            onConfirmPressed: onConfirmPressed,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
