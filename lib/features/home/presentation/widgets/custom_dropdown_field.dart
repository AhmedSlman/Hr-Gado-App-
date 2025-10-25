import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isEnabled;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          labelText,
          style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),

        // Dropdown
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide(color: AppColors.redFavColor, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: BorderSide(color: AppColors.redFavColor, width: 2),
            ),
            filled: true,
            fillColor: AppColors.white,
            enabled: isEnabled,
          ),
          style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
          dropdownColor: AppColors.white,
          items: items,
          onChanged: isEnabled ? onChanged : null,
          validator: validator,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ],
    );
  }
}
