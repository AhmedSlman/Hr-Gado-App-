import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/data/models/vacation_type.dart';
import 'package:hr_app/features/vacation/presentation/vacation_constants.dart';

class VacationTypeRadioRowWidget extends StatelessWidget {
  const VacationTypeRadioRowWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final VacationType selectedType;
  final ValueChanged<VacationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: VacationConstants.horizontalPadding,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              VacationConstants.chooseTypeLabel,
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: VacationConstants.normalLabel,
                    groupValue: selectedType == VacationType.normal
                        ? VacationConstants.normalLabel
                        : VacationConstants.longTermLabel,
                    onChanged: (v) {
                      if (v != null) onChanged(VacationType.normal);
                    },
                    activeColor: AppColors.primary,
                  ),
                  Text(
                    VacationConstants.normalLabel,
                    style: AppStyles.s16.copyWith(color: AppColors.grayText),
                  ),
                ],
              ),
            ),
            SizedBox(width: VacationConstants.radiosSpacing),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: VacationConstants.longTermLabel,
                    groupValue: selectedType == VacationType.normal
                        ? VacationConstants.normalLabel
                        : VacationConstants.longTermLabel,
                    onChanged: (v) {
                      if (v != null) onChanged(VacationType.longTerm);
                    },
                    activeColor: AppColors.primary,
                  ),
                  Text(
                    VacationConstants.longTermLabel,
                    style: AppStyles.s16.copyWith(color: AppColors.grayText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
