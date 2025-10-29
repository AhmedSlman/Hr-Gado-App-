import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/salary/presentation/components/salary_body_section.dart';

class SalaryView extends StatelessWidget {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "رصيدك من الراتب"),
            Expanded(child: SalaryBodySection()),
          ],
        ),
      ),
    );
  }
}
