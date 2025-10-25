import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';

class CheckOutDialog extends StatefulWidget {
  final String checkOutTime;
  final VoidCallback onConfirm;

  const CheckOutDialog({
    super.key,
    required this.checkOutTime,
    required this.onConfirm,
  });

  @override
  State<CheckOutDialog> createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  Timer? _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        _currentTime =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // علامة X
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Icon(Icons.close, color: AppColors.grayText, size: 24),
              ),
            ),

            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssets.image(IconsAssets.cat1, height: 30),
                SizedBox(width: 10.w),
                Text(
                  'تسجيل الانصراف',
                  style: AppStyles.s20Medium.copyWith(color: AppColors.primary),
                ),
              ],
            ),

            // الوقت المحدث
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(_currentTime, style: AppStyles.s20Medium),
            ),

            CustomButton(
              text: 'تأكيد تسجيل الانصراف',
              onPressed: widget.onConfirm,
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
