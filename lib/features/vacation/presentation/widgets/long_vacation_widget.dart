import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_text_form_field.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/vacation_constants.dart';

class LongVacationWidget extends StatelessWidget {
  const LongVacationWidget({super.key, required this.reasonController});

  final TextEditingController reasonController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: VacationConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              VacationConstants.reasonLabel,
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: reasonController,
            hintText: VacationConstants.reasonHint,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
