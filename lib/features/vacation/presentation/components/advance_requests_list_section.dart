import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_request_value_list_item_widget.dart';
import 'package:hr_app/features/vacation/presentation/views/advance_requests_view.dart';

class AdvanceRequestsListSection extends StatelessWidget {
  const AdvanceRequestsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (title: 'الأحد، ١٢ يناير', amount: '١٠٠٠', status: 'مقبولة'),
      (title: 'السبت، ٤ أكتوبر', amount: '٧٥٠', status: 'مرفوضة'),
      (title: 'الجمعة، ٢٥ سبتمبر', amount: '٥٠٠', status: 'مقبولة'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'طلبات السلفة السابقة',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdvanceRequestsView(),
                    ),
                  );
                },
                child: Text(
                  'عرض الكل',
                  style: AppStyles.s12Medium.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length > 2 ? 2 : items.length,
          itemBuilder: (context, index) {
            final it = items[index];
            return AdvanceRequestValueListItemWidget(
              titleDateText: it.title,
              amountText: it.amount,
              statusText: it.status,
            );
          },
        ),
      ],
    );
  }
}
