import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/comlaint_form_section.dart';
import 'package:hr_app/features/account/presentation/widgets/complaints_header_widget.dart';

class ComplaintsSuggestionsView extends StatelessWidget {
  const ComplaintsSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const CustomAppBar(title: 'تقديم الشكاوي و الاقتراحات'),
            SizedBox(height: 24.h),
            // Description text
            ComlaintsHeaderWidget(),
            SizedBox(height: 32.h),
            // Sub heading
            ComplaintFormSection(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
