import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class SuccessCreateDeductionDialog extends StatefulWidget {
  final String message;
  const SuccessCreateDeductionDialog({super.key, required this.message});

  @override
  State<SuccessCreateDeductionDialog> createState() =>
      _SuccessCreateDeductionDialogState();
}

class _SuccessCreateDeductionDialogState
    extends State<SuccessCreateDeductionDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      contentPadding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.primary),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Text(
                    'تم اضافة الجزاء بنجاح',
                    style: AppStyles.s20Medium.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                widget.message.isNotEmpty
                    ? widget.message
                    : "تم إنشاء الجزاء بنجاح.",
                style: AppStyles.caption.copyWith(color: AppColors.grayText),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ],
      ),
    );
  }
}
