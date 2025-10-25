import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/features/home/presentation/widgets/date_work_hours_widget.dart';
import 'package:hr_app/features/home/presentation/widgets/time_board_row_widget.dart';

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({
    super.key,
    required this.date,
    required this.workHours,
    this.isCheckedIn = false,
    this.isCheckedOut = false,
    this.onCheckIn,
    this.onCheckOut,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.showCompleted = false,
    this.isLoading = false,
    this.workStartTime = '09:00 ص',
    this.workEndTime = '05:00 م',
    this.lastTimeBeforeDeduction = '09:30 ص',
  });
  final String date;
  final String workHours;
  final bool isCheckedIn;
  final bool isCheckedOut;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final String checkInTime;
  final String checkOutTime;
  final bool showCompleted;
  final bool isLoading;
  final String workStartTime;
  final String workEndTime;
  final String lastTimeBeforeDeduction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        // color: AppColors.white,
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Column(
        children: [
          DateWorkHoursWidget(date: date, workHours: workHours),
          SizedBox(height: 10.h),
          TimeBoardRowWidget(
            isCheckedIn: isCheckedIn,
            checkInTime: checkInTime,
            checkOutTime: checkOutTime,
            showCompleted: showCompleted,
            workStartTime: workStartTime,
            workEndTime: workEndTime,
            lastTimeBeforeDeduction: lastTimeBeforeDeduction,
          ),
          SizedBox(height: 6.h),
          CustomButton(
            text: _getButtonText(),
            onPressed: (isCheckedOut || isLoading) ? null : _handleButtonPress,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (isCheckedOut) {
      return "تم تسجيل الانصراف";
    } else if (isCheckedIn) {
      return "تسجيل انصراف";
    } else {
      return "تسجيل حضور";
    }
  }

  void _handleButtonPress() {
    if (isCheckedIn) {
      onCheckOut?.call();
    } else {
      onCheckIn?.call();
    }
  }
}
