import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/vacation/presentation/components/vacation_advance_tap_bar_section.dart';

class VacationAdvanceView extends StatelessWidget {
  const VacationAdvanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "السلف والإجازات"),
            VactionAdvanceTapBar(),
          ],
        ),
      ),
    );
  }
}
