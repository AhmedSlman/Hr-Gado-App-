import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

enum AdvanceType { normal, longTerm }

class AdvanceTypeRadioRowWidget extends StatelessWidget {
  const AdvanceTypeRadioRowWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final AdvanceType selectedType;
  final ValueChanged<AdvanceType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio<AdvanceType>(
                  value: AdvanceType.normal,
                  groupValue: selectedType,
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    if (v != null) onChanged(v);
                  },
                ),
                Text('سلفة عادية', style: AppStyles.s16),
              ],
            ),
          ),
          SizedBox(width: 30.w),
          Expanded(
            child: Row(
              children: [
                Radio<AdvanceType>(
                  value: AdvanceType.longTerm,
                  groupValue: selectedType,
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    if (v != null) onChanged(v);
                  },
                ),
                Text('سلفة طويلة الأمد', style: AppStyles.s16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
