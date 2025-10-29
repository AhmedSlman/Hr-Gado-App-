import 'package:flutter/material.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/time_sheet_item_widget.dart';

class TimeSheetListViewSection extends StatelessWidget {
  const TimeSheetListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return TimeSheetItemWidget(
          date: "السبت، 15 ديسمبر 2024",
          checkInTime: "09:00 ص",
          checkOutTime: "05:00 م",
        );
      },
    );
  }
}
