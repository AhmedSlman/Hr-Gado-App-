import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AdvanceRequestListItemWidget extends StatelessWidget {
  const AdvanceRequestListItemWidget({
    super.key,
    required this.titleDateText,
    required this.daysCountText,
    required this.rangeDateText,
    required this.statusText,
  });

  final String titleDateText;
  final String daysCountText;
  final String rangeDateText;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = statusText.contains('مقبول')
        ? AppColors.deepGreenColor
        : AppColors.redFavColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
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
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
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
                        Text(rangeDateText, style: AppStyles.s14Medium),
                        Text(daysCountText, style: AppStyles.s14Medium),
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
