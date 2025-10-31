import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AdvanceNormalWidget extends StatelessWidget {
  const AdvanceNormalWidget({
    super.key,
    required this.lastAdvanceDate,
    required this.daysSinceLastAdvance,
    required this.accruedBalance,
  });

  final String lastAdvanceDate;
  final String daysSinceLastAdvance;
  final String accruedBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ السلفة السابقة',
                style: AppStyles.s16.copyWith(color: AppColors.primary),
              ),
              Text(lastAdvanceDate, style: AppStyles.s16),
            ],
          ),
          // const SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'تبقى على آخر سلفة',
          //       style: AppStyles.s16.copyWith(color: AppColors.primary),
          //     ),
          //     Text(daysSinceLastAdvance, style: AppStyles.s16),
          //   ],
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'الرصيد المحقق',
          //       style: AppStyles.s16.copyWith(color: AppColors.primary),
          //     ),
          //     Text(accruedBalance, style: AppStyles.s16),
          //   ],
          // ),
          SizedBox(height: 24.h),
          Container(height: 1, color: AppColors.lightBlue),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
