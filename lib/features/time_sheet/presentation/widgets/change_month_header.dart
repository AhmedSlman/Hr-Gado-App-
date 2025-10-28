import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ChangeMonthHeader extends StatefulWidget {
  const ChangeMonthHeader({super.key});

  @override
  State<ChangeMonthHeader> createState() => _ChangeMonthHeaderState();
}

class _ChangeMonthHeaderState extends State<ChangeMonthHeader> {
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = _getCurrentMonthYear();
  }

  String _getCurrentMonthYear() {
    final now = DateTime.now();
    final arabicMonths = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر",
    ];
    return "${arabicMonths[now.month - 1]} ${now.year}";
  }

  List<String> get availableDates {
    final List<String> arabicMonths = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر",
    ];

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    List<String> dates = [];

    dates.add("${arabicMonths[currentMonth - 1]} $currentYear");

    for (int month = currentMonth - 1; month >= 1; month--) {
      dates.add("${arabicMonths[month - 1]} $currentYear");
    }

    for (int year = currentYear - 1; year >= currentYear - 5; year--) {
      for (int month = 12; month >= 1; month--) {
        dates.add("${arabicMonths[month - 1]} $year");
      }
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text("مواعيد حضور وانصراف ", style: AppStyles.s16Medium),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedDate,
            style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            underline: Container(),
            items: availableDates.map((String date) {
              return DropdownMenuItem<String>(value: date, child: Text(date));
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedDate = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
