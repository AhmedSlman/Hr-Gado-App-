import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_request_list_item_widget.dart';

class VacationListViewSection extends StatelessWidget {
  VacationListViewSection({super.key});

  final items = [
    (
      title: '10-2025',
      days: '3 أيام',
      range: '2025-10-10 → 2025-10-12',
      status: 'مقبولة',
      color: AppColors.deepGreenColor,
    ),
    (
      title: '09-2025',
      days: '1 يوم',
      range: '2025-09-05 → 2025-09-05',
      status: 'مرفوضة',
      color: AppColors.redFavColor,
    ),
    (
      title: '08-2025',
      days: '2 يومين',
      range: '2025-08-20 → 2025-08-21',
      status: 'مقبولة',
      color: AppColors.deepGreenColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final it = items[index];
          return VacationRequestListItemWidget(
            titleDateText: it.title,
            daysCountText: it.days,
            rangeDateText: it.range,
            statusText: it.status,
            statusColor: it.color,
          );
        },
      ),
    );
  }
}
