import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/categories/data/categories_data.dart';
import 'package:hr_app/features/categories/presentation/components/categories_section.dart';
import 'package:hr_app/features/categories/router/categories_names.dart';
import 'package:hr_app/features/home/presentation/components/attendance_section.dart';
import 'package:hr_app/features/home/presentation/components/categories_list_view.dart';
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
                AttendanceSection(),
                SectionTitle(),
                CategoriesListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "الخصائص",
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        TextButton(
          onPressed: () {
            context.push(CategoriesRoutes.categories);
          },
          child: Text(
            "عرض الكل",
            style: AppStyles.s12Medium.copyWith(color: AppColors.grayText),
          ),
        ),
      ],
    );
  }
}
