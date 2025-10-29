import 'package:flutter/material.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_request_value_list_item_widget.dart';

class AdvancesListViewSection extends StatelessWidget {
  AdvancesListViewSection({super.key});

  final items = [
    (title: 'الأحد، ١٢ يناير', amount: '١٠٠٠', status: 'مقبولة'),
    (title: 'السبت، ٤ أكتوبر', amount: '٧٥٠', status: 'مرفوضة'),
    (title: 'الجمعة، ٢٥ سبتمبر', amount: '٥٠٠', status: 'مقبولة'),
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final it = items[index];
          return AdvanceRequestValueListItemWidget(
            titleDateText: it.title,
            amountText: it.amount,
            statusText: it.status,
          );
        },
      ),
    );
  }
}
