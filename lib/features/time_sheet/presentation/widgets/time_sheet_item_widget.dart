import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class TimeSheetItemWidget extends StatelessWidget {
  final String date;
  final String checkInTime;
  final String checkOutTime;

  const TimeSheetItemWidget({
    super.key,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 85,
            decoration: BoxDecoration(
              color: const Color.fromARGB(125, 42, 150, 213),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: AppStyles.s12Medium.copyWith(
                      color: AppColors.grayText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الحضور:",
                              style: AppStyles.s14Medium.copyWith(
                                color: AppColors.grayText,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              checkInTime,
                              style: AppStyles.s16Medium.copyWith(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الانصراف:",
                              style: AppStyles.s14Medium.copyWith(
                                color: AppColors.grayText,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              checkOutTime,
                              style: AppStyles.s16Medium.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
