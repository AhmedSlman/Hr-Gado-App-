import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class TimeBoardWidget extends StatelessWidget {
  const TimeBoardWidget({
    super.key,
    required this.title,
    required this.time,
    required this.subtitle,
  });

  final String title;
  final String time;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: AppColors.greyIcon,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(title, style: AppStyles.s12Medium),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              time,
              style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppStyles.s10Medium.copyWith(color: AppColors.greyIcon),
            ),
          ],
        ),
      ),
    );
  }
}
