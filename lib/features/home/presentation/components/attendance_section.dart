import 'package:flutter/material.dart';
import 'package:hr_app/features/home/presentation/widgets/date_work_hours_widget.dart';
import 'package:hr_app/features/home/presentation/widgets/time_board_row_widget.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [DateWorkHoursWidget(), TimeBoardRowWidget()]);
  }
}
