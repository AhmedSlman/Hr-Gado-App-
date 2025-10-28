import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class TimeSheetView extends StatelessWidget {
  const TimeSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "الحضور والانصراف"),
            ChangeMonthHeader(),
          ],
        ),
      ),
    );
  }
}

class ChangeMonthHeader extends StatelessWidget {
  const ChangeMonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("مواعيد حضور وانصراف ", style: AppStyles.s16Medium),
        Text(
          "يناير 2024",
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
