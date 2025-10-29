import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/time_sheet/presentation/components/time_sheet_list_view_section.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/change_month_header.dart';
import 'package:hr_app/features/time_sheet/presentation/components/permission_request_button.dart';

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
            Expanded(child: TimeSheetListViewSection()),
          ],
        ),
      ),
      floatingActionButton: PermissionRequestButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
