import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import 'package:hr_app/features/home/logic/home_cubit.dart';
import 'package:hr_app/features/home/logic/home_states.dart';

enum UserJobType { driver, sales, technician, other }

class ReportSummaryDialog extends StatefulWidget {
  final WorkReportModel workReport;
  final VoidCallback onConfirm;

  const ReportSummaryDialog({
    super.key,
    required this.workReport,
    required this.onConfirm,
  });

  @override
  State<ReportSummaryDialog> createState() => _ReportSummaryDialogState();
}

class _ReportSummaryDialogState extends State<ReportSummaryDialog> {
  bool _isLoading = false;

  void _handleConfirm(BuildContext context) {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // إرسال التقرير اليومي
    context.read<HomeCubit>().submitDailyReport(widget.workReport);
  }

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
    return BlocListener<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is DailyReportLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is DailyReportSuccess) {
          setState(() {
            _isLoading = false;
          });

          if (state.response.isSuccess) {
            // عرض رسالة النجاح وإغلاق الـ dialog بعد انتهاء setState
            // استخدام Future.delayed مباشرة لتأخير العرض حتى بعد انتهاء frame كامل
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && context.mounted) {
                CustomSnackBar.showSuccess(
                  context,
                  message: state.response.msg,
                );
                // تأخير إضافي قبل إغلاق dialog
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted && context.mounted && context.canPop()) {
                    context.pop();
                    widget.onConfirm();
                  }
                });
              }
            });
          } else {
            // عرض رسالة الخطأ بعد انتهاء setState
            // استخدام Future.delayed مباشرة لتأخير العرض حتى بعد انتهاء frame كامل
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && context.mounted) {
                CustomSnackBar.showError(context, message: state.response.msg);
              }
            });
          }
        } else if (state is DailyReportError) {
          setState(() {
            _isLoading = false;
          });
          // عرض رسالة الخطأ بعد انتهاء setState
          // استخدام Future.delayed مباشرة لتأخير العرض حتى بعد انتهاء frame كامل
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && context.mounted) {
              CustomSnackBar.showError(context, message: state.message);
            }
          });
        }
      },
      child: Dialog(
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
                    child: Icon(
                      Icons.close,
                      color: AppColors.grayText,
                      size: 24,
                    ),
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

                CustomButton(
                  text: 'تأكيد',
                  onPressed: _isLoading ? null : () => _handleConfirm(context),
                  isLoading: _isLoading,
                ),

                SizedBox(height: 16.h),
              ],
            ),
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
                      text: widget.workReport.devices ?? '-',
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
                      text: widget.workReport.overtimeHours ?? '-',
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
                      text: widget.workReport.soldDevices ?? '-',
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
                      text: widget.workReport.boughtDevices ?? '-',
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
                      text: widget.workReport.commercialDevices ?? '-',
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
                      text: widget.workReport.devices ?? '-',
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
                      text: widget.workReport.meters ?? '-',
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
                      text: widget.workReport.overtimeHours ?? '-',
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
        widget.workReport.report,
        style: AppStyles.s12Medium.copyWith(color: AppColors.grayText),
        textAlign: TextAlign.center,
      ),
    ]);

    return fields;
  }
}
