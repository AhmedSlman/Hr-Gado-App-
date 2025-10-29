import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AdvanceLongWidget extends StatelessWidget {
  const AdvanceLongWidget({
    super.key,
    required this.repaymentPeriod,
    required this.onRepaymentChanged,
  });

  final String repaymentPeriod;
  final ValueChanged<String> onRepaymentChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'حدد وقت السداد',
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: repaymentPeriod,
            style: AppStyles.s16.copyWith(color: AppColors.black),
            items: [
              DropdownMenuItem(
                value: 'شهر واحد',
                child: Text(
                  'شهر واحد',
                  style: AppStyles.s16.copyWith(color: AppColors.black),
                ),
              ),
              DropdownMenuItem(
                value: 'ثلاثة أشهر',
                child: Text(
                  'ثلاثة أشهر',
                  style: AppStyles.s16.copyWith(color: AppColors.black),
                ),
              ),
              DropdownMenuItem(
                value: 'ستة أشهر',
                child: Text(
                  'ستة أشهر',
                  style: AppStyles.s16.copyWith(color: AppColors.black),
                ),
              ),
              DropdownMenuItem(
                value: 'سنة',
                child: Text(
                  'سنة',
                  style: AppStyles.s16.copyWith(color: AppColors.black),
                ),
              ),
            ],
            onChanged: (v) {
              if (v != null) onRepaymentChanged(v);
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
