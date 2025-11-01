import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/emloyee_requsests_list_section.dart';

class EmployeeRequestsView extends StatelessWidget {
  const EmployeeRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const CustomAppBar(title: 'طلبات الموظفين'),
            EmployeeRequsetsListViewSection(),
          ],
        ),
      ),
    );
  }
}
