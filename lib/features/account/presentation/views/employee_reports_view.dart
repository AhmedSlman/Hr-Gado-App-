import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/employee_reports_list_section.dart';

class EmployeeReportsView extends StatelessWidget {
  const EmployeeReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const CustomAppBar(title: 'تقارير الموظفين'),
            EmployeeReportsListSection(),
          ],
        ),
      ),
    );
  }
}
