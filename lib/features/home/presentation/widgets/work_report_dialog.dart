import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import 'package:hr_app/features/home/presentation/widgets/custom_dropdown_field.dart';
import 'package:hr_app/features/home/presentation/widgets/custom_text_area_field.dart';

class WorkReportDialog extends StatefulWidget {
  final Function(WorkReportModel) onConfirm;

  const WorkReportDialog({super.key, required this.onConfirm});

  @override
  State<WorkReportDialog> createState() => _WorkReportDialogState();
}

class _WorkReportDialogState extends State<WorkReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reportController = TextEditingController();

  String _selectedDevices = '1';
  String _selectedMeters = '100';

  final List<String> _devicesList = ['1', '2', '3', '4', '5'];
  final List<String> _metersList = ['100', '200', '300', '400', '500'];

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
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
                'تقرير عمل اليوم',
                style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
              ),

              const SizedBox(height: 20),

              // عدد الأجهزة
              CustomDropdownField<String>(
                value: _selectedDevices,
                labelText: 'عدد الأجهزة',
                items: _devicesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDevices = newValue!;
                  });
                },
              ),

              SizedBox(height: 20.h),

              // عدد الأمتار
              CustomDropdownField<String>(
                value: _selectedMeters,
                labelText: 'عدد الأمتار',
                items: _metersList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMeters = newValue!;
                  });
                },
              ),

              SizedBox(height: 20.h),

              // تقرير عمل اليوم
              CustomTextAreaField(
                controller: _reportController,
                labelText: 'تقرير عمل اليوم',
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: 'إرسال التقرير',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final workReport = WorkReportModel(
                      devices: _selectedDevices,
                      meters: _selectedMeters,
                      report: _reportController.text,
                    );

                    context.pop();
                    widget.onConfirm(workReport); // إرسال الـ model
                  }
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
