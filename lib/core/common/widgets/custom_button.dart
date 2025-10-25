import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.height,
    this.width,
    this.textStyle,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.borderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    print('🔍 CustomButton - Building with isLoading: $isLoading');
    return Padding(
      padding: padding ?? EdgeInsets.only(top: 16.h),
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          height: height ?? 50.h,
          width: width ?? 360.w,
          decoration: BoxDecoration(
            color: (isLoading || onPressed == null)
                ? (backgroundColor ?? AppColors.primary).withOpacity(0.6)
                : backgroundColor ?? AppColors.primary,
            borderRadius: borderRadius ?? BorderRadius.circular(4.r),
            border: Border.all(color: borderColor ?? Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                ),
                SizedBox(width: 8.w),
              ] else if (leadingIcon != null) ...[
                leadingIcon!,
                SizedBox(width: 8.w),
              ],
              Text(
                isLoading ? "جاري التحميل..." : text,
                style:
                    textStyle ??
                    AppStyles.s16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (!isLoading && trailingIcon != null) ...[
                SizedBox(width: 8.w),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
