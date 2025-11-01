import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class ComlaintsTextFormField extends StatelessWidget {
  const ComlaintsTextFormField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'تقديم شكوى أو اقتراح',
            style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
          ),
        ),
        SizedBox(height: 16.h),
        // Text input field
        Container(
          constraints: BoxConstraints(minHeight: 200.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            maxLines: null,
            expands: false,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'اكتب شكوى أو اقتراح',
              hintStyle: AppStyles.s16.copyWith(color: AppColors.grayText),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppStyles.s16.copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
