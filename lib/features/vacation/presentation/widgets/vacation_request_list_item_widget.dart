import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class VacationRequestListItemWidget extends StatelessWidget {
  const VacationRequestListItemWidget({
    super.key,
    required this.titleDateText,
    required this.daysCountText,
    required this.rangeDateText,
    required this.statusText,
    required this.statusColor,
  });

  final String titleDateText;
  final String daysCountText;
  final String rangeDateText;
  final String statusText;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final Color effectiveStatusColor = statusText.contains('مقبول')
        ? AppColors.deepGreenColor
        : AppColors.redFavColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 14,
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
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
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
                        // الحالة

                        // من-إلى
                        Text(rangeDateText, style: AppStyles.s14Medium),
                        // عدد الأيام
                        Text(daysCountText, style: AppStyles.s14Medium),
                        Text(
                          statusText,
                          style: AppStyles.s14.copyWith(
                            color: effectiveStatusColor,
                          ),
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
