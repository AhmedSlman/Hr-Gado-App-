import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/utils/date_time_helper.dart';
import 'package:hr_app/features/home/presentation/widgets/time_board_item_widget.dart';

class TimeBoardRowWidget extends StatelessWidget {
  const TimeBoardRowWidget({
    super.key,
    this.isCheckedIn = false,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.showCompleted = false,
    this.workStartTime = '09:00 ص',
    this.workEndTime = '05:00 م',
    this.lastTimeBeforeDeduction = '09:30 ص',
  });

  final bool isCheckedIn;
  final String checkInTime;
  final String checkOutTime;
  final bool showCompleted;
  final String workStartTime;
  final String workEndTime;
  final String lastTimeBeforeDeduction;

  /// تحديد حالة الانصراف بناءً على مقارنة وقت الانصراف مع موعد الانصراف
  CheckOutStatus _getCheckOutStatus() {
    // إذا لم يتم تسجيل الانصراف
    if (checkOutTime.isEmpty || !isCheckedIn || workEndTime.isEmpty) {
      return CheckOutStatus.notCheckedOut;
    }

    // تحويل الأوقات إلى 24 ساعة للمقارنة
    final checkOut24 = DateTimeHelper.convertTo24Hour(checkOutTime);
    final workEnd24 = DateTimeHelper.convertTo24Hour(workEndTime);

    try {
      // تقسيم الأوقات إلى ساعات ودقائق
      final checkoutParts = checkOut24.split(':');
      final workEndParts = workEnd24.split(':');

      if (checkoutParts.length != 2 || workEndParts.length != 2) {
        return CheckOutStatus.notCheckedOut;
      }

      // تنظيف الدقائق من أي مسافات
      final checkoutHour = int.parse(checkoutParts[0].trim());
      final checkoutMinute = int.parse(checkoutParts[1].trim());
      final workEndHour = int.parse(workEndParts[0].trim());
      final workEndMinute = int.parse(workEndParts[1].trim());

      // حساب الوقت بالدقائق للمقارنة
      final checkoutMinutes = checkoutHour * 60 + checkoutMinute;
      final workEndMinutes = workEndHour * 60 + workEndMinute;

      // حساب الفرق بالدقائق
      final difference = checkoutMinutes - workEndMinutes;

      // إذا كان وقت الانصراف قبل موعد الانصراف (قبل الموعد)
      if (difference < 0) {
        return CheckOutStatus.early;
      }
      // إذا كان وقت الانصراف بعد موعد الانصراف بأكثر من 30 دقيقة (بعد الموعد)
      else if (difference > 30) {
        return CheckOutStatus.late;
      }
      // إذا كان وقت الانصراف في موعد الانصراف أو بعده بقليل (في الموعد)
      else {
        return CheckOutStatus.onTime;
      }
    } catch (e) {
      // في حالة حدوث خطأ، نعتبره لم يتم تسجيل الانصراف
      print('🔍 Error in _getCheckOutStatus: $e');
      print('🔍 checkOutTime: $checkOutTime, workEndTime: $workEndTime');
      return CheckOutStatus.notCheckedOut;
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد حالة الانصراف فقط إذا تم تسجيل الانصراف
    final checkOutStatus = _getCheckOutStatus();
    final isCheckOutWidget = isCheckedIn && checkOutTime.isNotEmpty;

    return Row(
      children: [
        TimeBoardWidget(
          title: isCheckedIn ? "موعد الغلق" : "موعد العمل",
          time: isCheckedIn ? workEndTime : workStartTime,
          subtitle: isCheckedIn
              ? "آخر موعد للانصراف $workEndTime"
              : "آخر موعد للتأخير $lastTimeBeforeDeduction",
          isCompleted: false,
          checkOutStatus: CheckOutStatus.notCheckedOut,
          workEndTime: workEndTime,
        ),
        SizedBox(width: 16.w),
        TimeBoardWidget(
          title: isCheckedIn ? "موعد الانصراف" : "موعد الحضور",
          time: isCheckedIn
              ? (checkOutTime.isNotEmpty ? checkOutTime : workEndTime)
              : (checkInTime.isNotEmpty ? checkInTime : "00:00"),
          subtitle: isCheckedIn ? "يمكنك الانصراف الآن" : "يمكنك تسجيل الحضور",
          isCompleted: showCompleted,
          // تمرير حالة الانصراف فقط للـ widget الثاني إذا تم تسجيل الانصراف
          checkOutStatus: isCheckOutWidget
              ? checkOutStatus
              : CheckOutStatus.notCheckedOut,
          workEndTime: workEndTime,
        ),
      ],
    );
  }
}
