import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_text_form_field.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.validator,
  });
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: controller,
            hintText: hint,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
