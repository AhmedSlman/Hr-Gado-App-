import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/vacation/presentation/components/advances_list_view_section.dart';

class AdvanceRequestsView extends StatelessWidget {
  const AdvanceRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'طلبات السلفة السابقة'),
            AdvancesListViewSection(),
          ],
        ),
      ),
    );
  }
}
