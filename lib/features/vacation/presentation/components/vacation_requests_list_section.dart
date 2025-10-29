import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/views/vacation_requests_view.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_request_list_item_widget.dart';

class VacationRequestsListSection extends StatelessWidget {
  const VacationRequestsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات افتراضية مؤقتة
    final items = [
      (
        title: 'السبت، ٤ أكتوبر ',
        days: '3 أيام',
        range: '١٢ يناير',
        status: 'مقبولة',
        color: AppColors.deepGreenColor,
      ),
      (
        title: 'السبت، ٤ أكتوبر ',
        days: '3 أيام',
        range: '١٢ يناير',
        status: 'مقبولة',
        color: AppColors.deepGreenColor,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'طلبات الإجازة السابقة',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  // Prefer app router navigation if available
                  try {
                    // go_router
                    // context.go(VacationRoutes.vacationRequests);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VacationRequestsView(),
                      ),
                    );
                  } catch (_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VacationRequestsView(),
                      ),
                    );
                  }
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
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length > 2 ? 2 : items.length,
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
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
