import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

/// ويدجيت لعرض حالة فارغة عندما تكون البيانات فارغة
/// يمكن استخدامه في جميع أنحاء التطبيق
class EmptyStateWidget extends StatelessWidget {
  /// الرسالة الرئيسية
  final String message;

  /// الرسالة الثانوية (اختيارية)
  final String? subtitle;

  /// مسار الصورة (اختياري)
  /// إذا لم يتم تحديده، سيتم استخدام أيقونة افتراضية
  final String? imagePath;

  /// أيقونة بدلاً من الصورة (اختياري)
  /// إذا تم تحديد imagePath، سيتم استخدام الصورة أولاً
  final IconData? icon;

  /// حجم الأيقونة
  final double? iconSize;

  /// لون الأيقونة
  final Color? iconColor;

  /// حجم الصورة
  final double? imageWidth;
  final double? imageHeight;

  /// زر إجراء (اختياري)
  final String? actionLabel;
  final VoidCallback? onAction;

  /// المسافات بين العناصر
  final double? spacing;
  final double? topPadding;
  final double? bottomPadding;

  /// محاذاة المحتوى
  final MainAxisAlignment mainAxisAlignment;

  /// عرض الصورة/الأيقونة
  final bool showImage;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.imageWidth,
    this.imageHeight,
    this.actionLabel,
    this.onAction,
    this.spacing,
    this.topPadding,
    this.bottomPadding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.showImage = true,
  });

  /// ويدجيت مبسط للرسالة فقط
  factory EmptyStateWidget.simple({
    required String message,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    double? topPadding,
    double? bottomPadding,
  }) {
    return EmptyStateWidget(
      message: message,
      icon: icon ?? Icons.inbox_outlined,
      iconSize: iconSize ?? 80,
      iconColor: iconColor ?? AppColors.grayText,
      showImage: false,
      topPadding: topPadding ?? 60,
      bottomPadding: bottomPadding ?? 60,
    );
  }

  /// ويدجيت مع صورة
  factory EmptyStateWidget.withImage({
    required String message,
    required String imagePath,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    double? imageWidth,
    double? imageHeight,
    double? topPadding,
    double? bottomPadding,
  }) {
    return EmptyStateWidget(
      message: message,
      subtitle: subtitle,
      imagePath: imagePath,
      imageWidth: imageWidth ?? 120,
      imageHeight: imageHeight ?? 120,
      actionLabel: actionLabel,
      onAction: onAction,
      topPadding: topPadding ?? 100,
      bottomPadding: bottomPadding ?? 80,
      showImage: true,
    );
  }

  /// ويدجيت مع أيقونة
  factory EmptyStateWidget.withIcon({
    required String message,
    required IconData icon,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    double? iconSize,
    Color? iconColor,
    double? topPadding,
    double? bottomPadding,
  }) {
    return EmptyStateWidget(
      message: message,
      subtitle: subtitle,
      icon: icon,
      iconSize: iconSize ?? 80,
      iconColor: iconColor ?? AppColors.grayText,
      actionLabel: actionLabel,
      onAction: onAction,
      topPadding: topPadding ?? 60,
      bottomPadding: bottomPadding ?? 60,
      showImage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final hasBoundedHeight = maxHeight < double.infinity;

        Widget content = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: topPadding?.h ?? 0,
          ),
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الصورة أو الأيقونة مع Container محسن
              if (showImage) ...[
                _buildImageOrIcon(),
                SizedBox(height: (spacing ?? 28).h),
              ],

              // الرسالة الرئيسية مع Container محسن
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  message,
                  style: AppStyles.s18Medium.copyWith(
                    color: AppColors.secondary,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // الرسالة الثانوية
              if (subtitle != null) ...[
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    subtitle!,
                    style: AppStyles.s14.copyWith(
                      color: AppColors.grayText.withOpacity(0.8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              // زر الإجراء
              if (actionLabel != null && onAction != null) ...[
                SizedBox(height: (spacing ?? 24).h),
                _buildActionButton(),
              ],

              if (bottomPadding != null) SizedBox(height: bottomPadding!.h),
            ],
          ),
        );

        // إذا كان هناك ارتفاع محدد، استخدم ConstrainedBox لتوسيط المحتوى
        if (hasBoundedHeight && maxHeight > 0) {
          content = ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: Center(child: content),
          );
        } else {
          // إذا لم يكن هناك ارتفاع محدد، استخدم Center فقط
          content = Center(child: content);
        }

        return SingleChildScrollView(child: content);
      },
    );
  }

  Widget _buildImageOrIcon() {
    // إذا كان هناك مسار صورة، استخدم الصورة
    if (imagePath != null) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.fillGrey,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          imagePath!,
          width: (imageWidth ?? 120).w,
          height: (imageHeight ?? 120).h,
          fit: BoxFit.contain,
        ),
      );
    }

    // إذا كان هناك أيقونة، استخدم الأيقونة مع Container محسن
    if (icon != null) {
      final iconColorValue = iconColor ?? AppColors.grayText;
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: iconColorValue.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: iconColorValue.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: (iconSize ?? 80).sp, color: iconColorValue),
      );
    }

    // افتراضي: أيقونة صندوق فارغ مع Container محسن
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.grayText.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grayText.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Icon(Icons.inbox_outlined, size: 80.sp, color: AppColors.grayText),
    );
  }

  Widget _buildActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          actionLabel!,
          style: AppStyles.s16Medium.copyWith(
            color: AppColors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
