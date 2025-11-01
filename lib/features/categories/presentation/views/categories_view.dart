import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/categories/presentation/components/categories_section.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: CustomAppBar(title: 'الخصائص', showBackButton: false),
            ),
            SizedBox(height: 16.h),
            CategoriesGridViewSection(),
          ],
        ),
      ),
    );
  }
}
