import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/home/presentation/widgets/time_board_item_widget.dart';

class TimeBoardRowWidget extends StatelessWidget {
  const TimeBoardRowWidget({
    super.key,
    this.isCheckedIn = false,
    this.checkInTime = '',
    this.checkOutTime = '',
  });

  final bool isCheckedIn;
  final String checkInTime;
  final String checkOutTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TimeBoardWidget(
          title: isCheckedIn ? "موعد الغلق" : "موعد العمل",
          time: isCheckedIn ? "05:00 م" : "09:00 ص",
          subtitle: isCheckedIn
              ? "آخر موعد للانصراف 5:30"
              : "آخر موعد للتأخير 9:30",
        ),
        SizedBox(width: 16.w),
        TimeBoardWidget(
          title: isCheckedIn ? "موعد الانصراف" : "موعد الحضور",
          time: isCheckedIn ? "05:00 م" : "09:00 ص",
          subtitle: isCheckedIn ? "يمكنك الانصراف الآن" : "يمكنك تسجيل الحضور",
        ),
      ],
    );
  }
}
