import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AdvanceRequestValueListItemWidget extends StatelessWidget {
  const AdvanceRequestValueListItemWidget({
    super.key,
    required this.titleDateText,
    required this.amountText,
    required this.statusText,
  });

  final String titleDateText; // التاريخ أعلى الكارت
  final String amountText; // قيمة السلفة (مثلاً ١٠٠٠)
  final String statusText; // الحالة (مقبولة/مرفوضة)

  @override
  Widget build(BuildContext context) {
    final Color statusColor = statusText.contains('مقبول')
        ? AppColors.deepGreenColor
        : AppColors.redFavColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        titleDateText,
                        style: AppStyles.s12Medium.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(amountText, style: AppStyles.s14Medium),
                        Text(
                          statusText,
                          style: AppStyles.s14.copyWith(color: statusColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
