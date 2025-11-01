import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/features/account/data/models/employee_request_type.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_request_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';
import 'package:hr_app/features/account/router/account_route_extra.dart';

class EmployeeRequsetsListViewSection extends StatelessWidget {
  EmployeeRequsetsListViewSection({super.key});

  final requests = [
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب اجازة',
      'details': '4 ايام',
      'type': 'vacation',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب سلفة',
      'details': '1000 ج',
      'type': 'normal_advance',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب اجازة',
      'details': '4 ايام',
      'type': 'vacation',
    },
    {
      'employeeName': 'طارق على',
      'date': 'السبت, 4 يناير',
      'requestType': 'طلب سلفة',
      'details': '5000 ج',
      'type': 'long_term_advance',
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
              // Navigate to request details with request type via extra
              final requestTypeString = request['type'] ?? 'vacation';
              final requestType = _parseRequestType(requestTypeString);
              context.push(
                AccountRoutes.employeeRequestDetails,
                extra: EmployeeRequestDetailsExtra(requestType: requestType),
              );
            },
          );
        },
      ),
    );
  }

  EmployeeRequestType _parseRequestType(String type) {
    switch (type) {
      case 'vacation':
        return EmployeeRequestType.vacation;
      case 'normal_advance':
        return EmployeeRequestType.normalAdvance;
      case 'long_term_advance':
        return EmployeeRequestType.longTermAdvance;
      default:
        return EmployeeRequestType.vacation;
    }
  }
}
