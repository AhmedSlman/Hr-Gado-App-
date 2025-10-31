import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';

class ThemedDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            datePickerTheme: theme.datePickerTheme.copyWith(
              headerForegroundColor: AppColors.white,
              headerBackgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: AppColors.white,
              elevation: 8,
              shadowColor: AppColors.primary.withOpacity(0.15),
              dayShape: MaterialStateProperty.all(const CircleBorder()),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.white;
                }
                return AppColors.primary;
              }),
              dayOverlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.primary.withOpacity(0.08);
                }
                return Colors.transparent;
              }),
              rangePickerHeaderForegroundColor: AppColors.white,
              rangePickerHeaderBackgroundColor: AppColors.primary,
              rangePickerElevation: 8,
              rangePickerShadowColor: AppColors.primary.withOpacity(0.15),
              yearForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.white;
                }
                return AppColors.primary;
              }),
              yearOverlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.primary.withOpacity(0.08);
                }
                return Colors.transparent;
              }),
              yearShape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              rangeSelectionOverlayColor: MaterialStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
            ),
            dialogTheme: theme.dialogTheme.copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 8,
              shadowColor: AppColors.primary.withOpacity(0.15),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
