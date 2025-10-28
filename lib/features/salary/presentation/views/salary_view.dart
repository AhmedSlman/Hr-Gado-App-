import 'package:flutter/material.dart';
import '../components/salary_components.dart';

class SalaryView extends StatelessWidget {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            // Compose components only. No logic and no design here.
            SalaryHeaderSection(),
            SalaryBodySection(),
          ],
        ),
      ),
    );
  }
}
