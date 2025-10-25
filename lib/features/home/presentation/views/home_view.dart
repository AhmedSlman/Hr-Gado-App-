import 'package:flutter/material.dart';
import 'package:hr_app/features/categories/presentation/components/categories_section.dart';
import 'package:hr_app/features/home/presentation/components/attendance_section.dart';
import 'package:hr_app/features/home/presentation/components/home_header_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const HomeHeaderSection(),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                AttendanceSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
