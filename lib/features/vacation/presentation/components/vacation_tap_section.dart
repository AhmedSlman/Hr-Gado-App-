import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/vacation/data/models/vacation_type.dart';
import 'package:hr_app/features/vacation/presentation/widgets/days_required_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_type_radio_row_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_date_field_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/long_vacation_widget.dart';
import 'package:hr_app/features/vacation/presentation/widgets/normal_vacation_widget.dart';
import 'package:hr_app/core/common/widgets/themed_date_picker.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/features/vacation/presentation/components/vacation_requests_list_section.dart';

class VacationTapSection extends StatefulWidget {
  const VacationTapSection({super.key});

  @override
  State<VacationTapSection> createState() => _VacationTapSectionState();
}

class _VacationTapSectionState extends State<VacationTapSection> {
  VacationType _selectedType = VacationType.normal;
  final TextEditingController _reasonController = TextEditingController();

  final int _totalDays = 21;
  final int _consumedDays = 9;

  DateTime? _startDate;
  DateTime? _endDate;

  String _formatDate(DateTime? date) {
    if (date == null) return "اختر التاريخ";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = (isStart ? _startDate : _endDate) ?? DateTime.now();
    final picked = await ThemedDatePicker.show(
      context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  int? get _requestedDays {
    if (_startDate == null || _endDate == null) return null;
    final diff = _endDate!.difference(_startDate!).inDays;
    return diff.abs() + 1; // شامل اليومين
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _remainingDays => _totalDays - _consumedDays;
  bool get _canSubmit {
    if (_selectedType == VacationType.normal) {
      return _startDate != null && _endDate != null && _requestedDays != null;
    }
    return _reasonController.text.trim().isNotEmpty;
  }

  void _handleSubmit(BuildContext context) {
    if (!_canSubmit) {
      context.showSnack('يرجى استكمال البيانات المطلوبة');
      return;
    }
    // TODO: ربط API لاحقاً
    context.showSnack('تم إرسال الطلب بنجاح');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          VacationTypeRadioRowWidget(
            selectedType: _selectedType,
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          if (_selectedType == VacationType.normal) ...[
            // stats
            NormalVacationWidget(
              totalDays: _totalDays,
              consumedDays: _consumedDays,
              remainingDays: _remainingDays,
            ),
          ] else ...[
            LongVacationWidget(reasonController: _reasonController),
          ],
          SizedBox(height: 20.h),
          VacationDateFieldWidget(
            label: "تاريخ بداية الإجازة",
            dateText: _formatDate(_startDate),
            onTap: () => _pickDate(isStart: true),
          ),
          const SizedBox(height: 12),
          VacationDateFieldWidget(
            label: "تاريخ نهاية الإجازة",
            dateText: _formatDate(_endDate),
            onTap: () => _pickDate(isStart: false),
          ),
          SizedBox(height: 16.h),
          DaysRequiredWidget(requestedDays: _requestedDays),
          const SizedBox(height: 24),
          CustomButton(
            height: 45.h,
            width: 200.w,
            text: "إرسال الطلب",
            onPressed: _canSubmit ? () => _handleSubmit(context) : null,
          ),
          SizedBox(height: 16.h),
          const VacationRequestsListSection(),
        ],
      ),
    );
  }
}

extension on BuildContext {
  void showSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
