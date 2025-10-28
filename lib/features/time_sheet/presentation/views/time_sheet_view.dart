import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/change_month_header.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class TimeSheetView extends StatelessWidget {
  const TimeSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillGrey,
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "الحضور والانصراف"),
            ChangeMonthHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TimeSheetItemWidget(
                      date: "السبت، 15 ديسمبر 2024",
                      checkInTime: "09:00 ص",
                      checkOutTime: "05:00 م",
                    ),
                    TimeSheetItemWidget(
                      date: "الأحد، 16 ديسمبر 2024",
                      checkInTime: "09:15 ص",
                      checkOutTime: "05:30 م",
                    ),
                    TimeSheetItemWidget(
                      date: "الاثنين، 17 ديسمبر 2024",
                      checkInTime: "08:45 ص",
                      checkOutTime: "05:15 م",
                    ),
                    TimeSheetItemWidget(
                      date: "الثلاثاء، 18 ديسمبر 2024",
                      checkInTime: "09:30 ص",
                      checkOutTime: "06:00 م",
                    ),
                    TimeSheetItemWidget(
                      date: "الأربعاء، 19 ديسمبر 2024",
                      checkInTime: "08:30 ص",
                      checkOutTime: "05:45 م",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // الخط الأزرق من اليمين
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
          // المحتوى
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صف التاريخ
                  Text(
                    date,
                    style: AppStyles.s16Medium.copyWith(
                      color: AppColors.grayText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // صف معاد الحضور والانصراف
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "معاد الحضور",
                              style: AppStyles.s12.copyWith(
                                color: AppColors.greyIcon,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              checkInTime,
                              style: AppStyles.s14Medium.copyWith(
                                color: AppColors.deepGreenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "معاد الانصراف",
                              style: AppStyles.s12.copyWith(
                                color: AppColors.greyIcon,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              checkOutTime,
                              style: AppStyles.s14Medium.copyWith(
                                color: AppColors.orangeColor,
                              ),
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
