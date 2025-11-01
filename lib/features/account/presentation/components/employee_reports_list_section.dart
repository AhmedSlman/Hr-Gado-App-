import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_report_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';

class EmployeeReportsListSection extends StatelessWidget {
  EmployeeReportsListSection({super.key});

  final reports = [
    {
      'date': 'الاربعاء, 1 يناير',
      'employeeName': 'طارق على',
      'numberOfDevices': '8',
      'numberOfMeters': '1.5',
    },
    {
      'date': 'الاربعاء, 1 يناير',
      'employeeName': 'طارق على',
      'numberOfDevices': '8',
      'numberOfMeters': '1.5',
    },
    {
      'date': 'الاربعاء, 1 يناير',
      'employeeName': 'طارق على',
      'numberOfDevices': '8',
      'numberOfMeters': '1.5',
    },
    {
      'date': 'الاربعاء, 1 يناير',
      'employeeName': 'طارق على',
      'numberOfDevices': '8',
      'numberOfMeters': '1.5',
    },
    {
      'date': 'الاربعاء, 1 يناير',
      'employeeName': 'طارق على',
      'numberOfDevices': '8',
      'numberOfMeters': '1.5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
                return EmployeeReportCardWidget(
                  date: report['date']!,
                  employeeName: report['employeeName']!,
                  numberOfDevices: report['numberOfDevices']!,
                  numberOfMeters: report['numberOfMeters']!,
                  onTap: () {
                    context.push(AccountRoutes.employeeReportDetails);
                  },
                );
        },
      ),
    );
  }
}


