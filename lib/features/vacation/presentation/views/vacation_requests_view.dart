import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/vacation/presentation/components/vacation_list_view_section.dart';

class VacationRequestsView extends StatelessWidget {
  const VacationRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'طلبات الإجازة السابقة'),
            VacationListViewSection(),
          ],
        ),
      ),
    );
  }
}
