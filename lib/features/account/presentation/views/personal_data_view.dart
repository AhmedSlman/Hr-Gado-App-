import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/personal_data_section.dart';

class PersonalDataView extends StatelessWidget {
  const PersonalDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "البيانات الشخصية"),

            SizedBox(height: 32.h),
            // Profile picture
            PerseonalDataSection(),
          ],
        ),
      ),
    );
  }
}
