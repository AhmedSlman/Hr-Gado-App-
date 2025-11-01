import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';

enum UserJobType {
  driver,
  sales,
  technician,
  other,
}

class ReportSummaryDialog extends StatelessWidget {
  final WorkReportModel workReport;
  final VoidCallback onConfirm;

  const ReportSummaryDialog({
    super.key,
    required this.workReport,
    required this.onConfirm,
  });

  UserJobType get _userJobType {
    final jobType = UserHelper.userJobType?.toLowerCase() ?? '';
    switch (jobType) {
      case 'driver':
        return UserJobType.driver;
      case 'sales':
        return UserJobType.sales;
      case 'technician':
        return UserJobType.technician;
      default:
        return UserJobType.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // علامة X
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.close, color: AppColors.grayText, size: 24),
                ),
              ),

              // العنوان
              Text(
                "الرجاء التاكد من ملأ البيانات بطريقة صحيحة قبل الارسال حتى لا يتم تطبيق اللوائح فى حالة التلاعب",
                style: AppStyles.s16Light,
                textAlign: TextAlign.center,
              ),
              Divider(color: AppColors.primary),

              const SizedBox(height: 20),

              // Display fields based on user type
              ..._buildSummaryFields(),

              const SizedBox(height: 20),

              CustomButton(text: 'تأكيد', onPressed: onConfirm),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSummaryFields() {
    final fields = <Widget>[];

    switch (_userJobType) {
      case UserJobType.driver:
        // Driver: عدد الأجهزة، ساعات عمل إضافية، تقرير عمل اليوم
        fields.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأجهزة: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.devices ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "ساعات عمل إضافية: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.overtimeHours ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]);
        break;

      case UserJobType.sales:
        // Sales: عدد الأجهزة المباعة، عدد الأجهزة المشتراة، عدد التجاري
        fields.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأجهزة المباعة: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.soldDevices ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأجهزة المشتراة: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.boughtDevices ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأجهزة التجارية: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.commercialDevices ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]);
        break;

      case UserJobType.technician:
        // Technician: عدد الأجهزة، عدد الأمتار
        fields.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأجهزة: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.devices ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "عدد الأمتار: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.meters ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]);
        break;

      case UserJobType.other:
        // Other: ساعات عمل إضافية فقط
        fields.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "ساعات عمل إضافية: ",
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: workReport.overtimeHours ?? '-',
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]);
        break;
    }

    // Add report field for all types
    fields.addAll([
      SizedBox(height: 12.h),
      Align(
        alignment: AlignmentGeometry.centerRight,
        child: Text(
          "تقرير العمل :",
          style: AppStyles.s14Medium.copyWith(color: AppColors.black),
        ),
      ),
      SizedBox(height: 6.h),
      Text(
        workReport.report,
        style: AppStyles.s12Medium.copyWith(color: AppColors.grayText),
        textAlign: TextAlign.center,
      ),
    ]);

    return fields;
  }
}
