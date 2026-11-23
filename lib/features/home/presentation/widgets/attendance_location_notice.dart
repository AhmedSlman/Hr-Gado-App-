import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Shown before the employee confirms the action and before location permission.
class AttendanceLocationNotice extends StatelessWidget {
  const AttendanceLocationNotice({super.key});

  static const explanation =
      'عند التأكيد، يستخدم Gado HR موقعك الحالي ويرسله إلى خادم جهة عملك '
      'مع طلب تسجيل الحضور أو الانصراف. يُستخدم الموقع لهذه العملية فقط، '
      'ولا يتم تتبع موقعك باستمرار أو أثناء إغلاق التطبيق.';

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF6FB),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'استخدام الموقع لتسجيل الحضور والانصراف',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          explanation,
          style: TextStyle(
            fontSize: 13,
            height: 1.7,
            color: AppColors.grayText,
          ),
        ),
      ],
    ),
  );
}
