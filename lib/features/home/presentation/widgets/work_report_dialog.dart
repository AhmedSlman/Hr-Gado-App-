import 'report_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import 'package:hr_app/features/home/presentation/widgets/custom_dropdown_field.dart';
import 'package:hr_app/features/home/presentation/widgets/custom_text_area_field.dart';

enum UserJobType { driver, sales, technician, other }

class WorkReportDialog extends StatefulWidget {
  final Function(WorkReportModel) onConfirm;

  const WorkReportDialog({super.key, required this.onConfirm});

  @override
  State<WorkReportDialog> createState() => _WorkReportDialogState();
}

class _WorkReportDialogState extends State<WorkReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reportController = TextEditingController();

  // Driver & Technician
  String? _selectedDevices;
  String? _installationDevices;
  String? _supplyDevices;

  // Technician only
  String? _selectedMeters;

  // Driver & Other
  String? _selectedOvertimeHours;

  // Sales only
  String? _selectedSoldDevices;
  String? _selectedBoughtDevices;
  String? _selectedCommercialDevices;

  // Dropdown lists
  final List<String> _overtimeHoursList = List.generate(12, (i) => '$i');

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
  void initState() {
    super.initState();
    // Initialize default values based on user type
    switch (_userJobType) {
      case UserJobType.driver:
        _installationDevices = '0';
        _supplyDevices = '0';
        _selectedOvertimeHours = _overtimeHoursList.first;
        break;
      case UserJobType.sales:
        _selectedSoldDevices = '0';
        _selectedBoughtDevices = '0';
        _selectedCommercialDevices = '0';
        break;
      case UserJobType.technician:
        _selectedDevices = '0';
        _selectedMeters = '0';
        break;
      case UserJobType.other:
        _selectedOvertimeHours = _overtimeHoursList.first;
        break;
    }
  }

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
                  'تقرير عمل اليوم',
                  style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
                ),

                const SizedBox(height: 20),

                // Render fields based on user type
                ..._buildFieldsByUserType(),

                const SizedBox(height: 20),

                CustomButton(
                  text: 'إرسال التقرير',
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _validateFields()) {
                      final workReport = _buildWorkReport();
                      context.pop();
                      widget.onConfirm(workReport);
                    }
                  },
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFieldsByUserType() {
    final fields = <Widget>[];

    switch (_userJobType) {
      case UserJobType.driver:
        // Driver: عدد الأجهزة، ساعات عمل إضافية، تقرير عمل اليوم
        fields.addAll([
          ReportNumberField(
            initialValue: _installationDevices,
            label: 'عدد أجهزة التركيب',
            onChanged: (value) => _installationDevices = value,
          ),
          SizedBox(height: 20.h),
          ReportNumberField(
            initialValue: _supplyDevices,
            label: 'عدد أجهزة التوريد',
            onChanged: (value) => _supplyDevices = value,
          ),
          SizedBox(height: 20.h),
          CustomDropdownField<String>(
            value: _selectedOvertimeHours,
            labelText: 'ساعات عمل إضافية',
            items: _overtimeHoursList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOvertimeHours = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار ساعات العمل الإضافية' : null,
          ),
          SizedBox(height: 20.h),
          CustomTextAreaField(
            controller: _reportController,
            labelText: 'تقرير عمل اليوم',
            validator: (value) =>
                value?.isEmpty ?? true ? 'يجب إدخال تقرير عمل اليوم' : null,
          ),
        ]);
        break;

      case UserJobType.sales:
        // Sales: عدد الأجهزة المباعة، عدد الأجهزة المشتراة، عدد التجاري، تقرير عمل اليوم
        fields.addAll([
          ReportNumberField(
            initialValue: _selectedSoldDevices,
            label: 'عدد الأجهزة المباعة',
            onChanged: (value) => _selectedSoldDevices = value,
          ),
          SizedBox(height: 20.h),
          ReportNumberField(
            initialValue: _selectedBoughtDevices,
            label: 'عدد الأجهزة المشتراة',
            onChanged: (value) => _selectedBoughtDevices = value,
          ),
          SizedBox(height: 20.h),
          ReportNumberField(
            initialValue: _selectedCommercialDevices,
            label: 'عدد الأجهزة التجارية',
            onChanged: (value) => _selectedCommercialDevices = value,
          ),
          SizedBox(height: 20.h),
          CustomTextAreaField(
            controller: _reportController,
            labelText: 'تقرير عمل اليوم',
            validator: (value) =>
                value?.isEmpty ?? true ? 'يجب إدخال تقرير عمل اليوم' : null,
          ),
        ]);
        break;

      case UserJobType.technician:
        // Technician: عدد الأجهزة، عدد الأمتار، تقرير عمل اليوم
        fields.addAll([
          ReportNumberField(
            initialValue: _selectedDevices,
            label: 'عدد الأجهزة',
            onChanged: (value) => _selectedDevices = value,
          ),
          SizedBox(height: 20.h),
          ReportNumberField(
            initialValue: _selectedMeters,
            label: 'عدد الأمتار',
            decimal: true,
            onChanged: (value) => _selectedMeters = value,
          ),
          SizedBox(height: 20.h),
          CustomTextAreaField(
            controller: _reportController,
            labelText: 'تقرير عمل اليوم',
            validator: (value) =>
                value?.isEmpty ?? true ? 'يجب إدخال تقرير عمل اليوم' : null,
          ),
        ]);
        break;

      case UserJobType.other:
        // Other: ساعات عمل إضافية، تقرير عمل اليوم
        fields.addAll([
          CustomDropdownField<String>(
            value: _selectedOvertimeHours,
            labelText: 'ساعات عمل إضافية',
            items: _overtimeHoursList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOvertimeHours = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار ساعات العمل الإضافية' : null,
          ),
          SizedBox(height: 20.h),
          CustomTextAreaField(
            controller: _reportController,
            labelText: 'تقرير عمل اليوم',
            validator: (value) =>
                value?.isEmpty ?? true ? 'يجب إدخال تقرير عمل اليوم' : null,
          ),
        ]);
        break;
    }

    return fields;
  }

  bool _validateFields() {
    switch (_userJobType) {
      case UserJobType.driver:
        return _installationDevices != null &&
            _supplyDevices != null &&
            _selectedOvertimeHours != null &&
            _reportController.text.isNotEmpty;
      case UserJobType.sales:
        return _selectedSoldDevices != null &&
            _selectedBoughtDevices != null &&
            _selectedCommercialDevices != null &&
            _reportController.text.isNotEmpty;
      case UserJobType.technician:
        return _selectedDevices != null &&
            _selectedMeters != null &&
            _reportController.text.isNotEmpty;
      case UserJobType.other:
        return _selectedOvertimeHours != null &&
            _reportController.text.isNotEmpty;
    }
  }

  WorkReportModel _buildWorkReport() {
    return WorkReportModel(
      report: _reportController.text,
      devices: _selectedDevices,
      installationDevices: _installationDevices,
      supplyDevices: _supplyDevices,
      meters: _selectedMeters,
      overtimeHours: _selectedOvertimeHours,
      soldDevices: _selectedSoldDevices,
      boughtDevices: _selectedBoughtDevices,
      commercialDevices: _selectedCommercialDevices,
    );
  }
}
