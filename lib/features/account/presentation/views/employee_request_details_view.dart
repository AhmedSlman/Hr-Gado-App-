import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/data/models/employee_request_type.dart';
import 'package:hr_app/features/account/presentation/components/employee_requset_section.dart';

class EmployeeRequsetDetailsView extends StatelessWidget {
  final EmployeeRequestType requestType;

  const EmployeeRequsetDetailsView({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(title: ""),
              EmployeeRequestSection(requestType: requestType),
            ],
          ),
        ),
      ),
    );
  }
}
