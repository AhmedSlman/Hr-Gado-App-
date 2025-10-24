import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key, required this.onTap});
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          "هل نسيت كلمة المرور ؟",
          style: AppStyles.s12Medium.copyWith(color: AppColors.grayText),
        ),
      ),
    );
  }
}
