import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import '../components/company_rules_content_section.dart';

class CompanyRulesView extends StatelessWidget {
  const CompanyRulesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 32.h),
            CustomAppBar(title: 'قوانين الشركة', showBackButton: true),

            const Expanded(child: CompanyRulesContentSection()),
          ],
        ),
      ),
    );
  }
}
