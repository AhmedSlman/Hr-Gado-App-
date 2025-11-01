import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/personal_data_section.dart';

class PersonalDataView extends StatelessWidget {
  final int employeeId;

  const PersonalDataView({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "البيانات الشخصية"),
            Expanded(child: PersonalDataSection()),
          ],
        ),
      ),
    );
  }
}
