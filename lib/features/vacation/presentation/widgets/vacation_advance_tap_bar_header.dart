import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class VacationAndAdvanceTapBarHeaderWidget extends StatelessWidget {
  final TabController tabController;

  const VacationAndAdvanceTapBarHeaderWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.primary,
        labelStyle: AppStyles.s16Medium,
        unselectedLabelStyle: AppStyles.s16Medium,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "السلف"),
          Tab(text: "الاجازات"),
        ],
      ),
    );
  }
}
