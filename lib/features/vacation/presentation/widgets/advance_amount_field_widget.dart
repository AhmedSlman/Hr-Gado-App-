import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_text_form_field.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AdvanceAmountFieldWidget extends StatelessWidget {
  const AdvanceAmountFieldWidget({
    super.key,
    required this.controller,
    this.labelText = 'المبلغ المطلوب للسلفة',
    this.hintText = 'أدخل المبلغ المطلوب للسلفة',
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;

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
              labelText,
              style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: controller,
            hintText: hintText,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
