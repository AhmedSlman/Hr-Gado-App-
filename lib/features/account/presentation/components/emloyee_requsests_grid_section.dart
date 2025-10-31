import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_request_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';

class EmployeeRequsetsGridSection extends StatelessWidget {
  EmployeeRequsetsGridSection({super.key});

  final requests = [
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب اجازة',
      'details': '4 ايام',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب سلفة',
      'details': '1000 ج',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب اجازة',
      'details': '4 ايام',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب سلفة',
      'details': '1000 ج',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return EmployeeRequestCardWidget(
            employeeName: request['employeeName']!,
            date: request['date']!,
            requestType: request['requestType']!,
            details: request['details']!,
            onTap: () {
              // Navigate to request details (employee_reports_view)
              context.push(AccountRoutes.employeeReports);
            },
          );
        },
      ),
    );
  }
}
