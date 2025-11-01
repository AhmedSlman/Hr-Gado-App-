import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/delay_duration_dropdown.dart';

class PermissionRequestDialogWidget extends StatelessWidget {
  final String selectedPermissionType;
  final String? selectedDelayDuration;
  final List<String> delayDurations;
  final Function(String) onPermissionTypeChanged;
  final Function(String?) onDelayDurationChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isLoading;

  const PermissionRequestDialogWidget({
    super.key,
    required this.selectedPermissionType,
    required this.selectedDelayDuration,
    required this.delayDurations,
    required this.onPermissionTypeChanged,
    required this.onDelayDurationChanged,
    required this.onSubmit,
    required this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => context.pop(),
                child: Icon(Icons.close, color: AppColors.primary),
              ),
            ),
            Text(
              "طلب إذن",
              style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: 10.h),

            // Radio buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "اذن حضور",
                        groupValue: selectedPermissionType,
                        onChanged: (value) {
                          onPermissionTypeChanged(value!);
                        },
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        "اذن حضور",
                        style: AppStyles.s16.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "اذن انصراف",
                        groupValue: selectedPermissionType,
                        onChanged: (value) {
                          onPermissionTypeChanged(value!);
                        },
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        "اذن انصراف",
                        style: AppStyles.s16.copyWith(
                          color: AppColors.grayText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "حدد مدة التأخير",
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
            ),
            SizedBox(height: 10.h),
            DelayDurationDropdown(
              selectedValue: selectedDelayDuration,
              items: delayDurations,
              onChanged: onDelayDurationChanged,
            ),
            SizedBox(height: 14.h),
            CustomButton(
              text: "إرسال طلب",
              onPressed: (isLoading || selectedDelayDuration == null)
                  ? null
                  : onSubmit,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
