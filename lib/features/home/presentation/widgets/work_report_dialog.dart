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

  // Technician only
  String? _selectedMeters;

  // Driver & Other
  String? _selectedOvertimeHours;

  // Sales only
  String? _selectedSoldDevices;
  String? _selectedBoughtDevices;
  String? _selectedCommercialDevices;

  // Dropdown lists
  final List<String> _devicesList = List.generate(50, (i) => '${i + 1}');
  final List<String> _metersList = List.generate(50, (i) => '${(i + 1) * 50}');
  final List<String> _overtimeHoursList = List.generate(12, (i) => '${i + 1}');
  final List<String> _soldDevicesList = List.generate(100, (i) => '${i + 1}');
  final List<String> _boughtDevicesList = List.generate(100, (i) => '${i + 1}');
  final List<String> _commercialDevicesList = List.generate(
    100,
    (i) => '${i + 1}',
  );

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
        _selectedDevices = _devicesList.first;
        _selectedOvertimeHours = _overtimeHoursList.first;
        break;
      case UserJobType.sales:
        _selectedSoldDevices = _soldDevicesList.first;
        _selectedBoughtDevices = _boughtDevicesList.first;
        _selectedCommercialDevices = _commercialDevicesList.first;
        break;
      case UserJobType.technician:
        _selectedDevices = _devicesList.first;
        _selectedMeters = _metersList.first;
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
          CustomDropdownField<String>(
            value: _selectedDevices,
            labelText: 'عدد الأجهزة',
            items: _devicesList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDevices = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأجهزة' : null,
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
          CustomDropdownField<String>(
            value: _selectedSoldDevices,
            labelText: 'عدد الأجهزة المباعة',
            items: _soldDevicesList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSoldDevices = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأجهزة المباعة' : null,
          ),
          SizedBox(height: 20.h),
          CustomDropdownField<String>(
            value: _selectedBoughtDevices,
            labelText: 'عدد الأجهزة المشتراة',
            items: _boughtDevicesList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedBoughtDevices = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأجهزة المشتراة' : null,
          ),
          SizedBox(height: 20.h),
          CustomDropdownField<String>(
            value: _selectedCommercialDevices,
            labelText: 'عدد الأجهزة التجارية',
            items: _commercialDevicesList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCommercialDevices = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأجهزة التجارية' : null,
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
          CustomDropdownField<String>(
            value: _selectedDevices,
            labelText: 'عدد الأجهزة',
            items: _devicesList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDevices = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأجهزة' : null,
          ),
          SizedBox(height: 20.h),
          CustomDropdownField<String>(
            value: _selectedMeters,
            labelText: 'عدد الأمتار',
            items: _metersList.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMeters = newValue!;
              });
            },
            validator: (value) =>
                value == null ? 'يجب اختيار عدد الأمتار' : null,
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
        return _selectedDevices != null &&
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
      meters: _selectedMeters,
      overtimeHours: _selectedOvertimeHours,
      soldDevices: _selectedSoldDevices,
      boughtDevices: _selectedBoughtDevices,
      commercialDevices: _selectedCommercialDevices,
    );
  }
}
