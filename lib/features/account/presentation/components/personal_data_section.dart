import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/account/presentation/widgets/personal_data_field_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';

class PerseonalDataSection extends StatelessWidget {
  const PerseonalDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePictureWidget(
          onTap: () {
            // Handle photo change
          },
        ),
        SizedBox(height: 32.h),
        // Personal data fields
        Column(
          children: [
            PersonalDataFieldWidget(label: 'الاسم', value: 'محمد کمال'),
            PersonalDataFieldWidget(label: 'الوظيفة', value: 'خدمة عملاء'),
            PersonalDataFieldWidget(
              label: 'رقم الهاتف',
              value: '010100101010101010',
            ),
            PersonalDataFieldWidget(label: 'المدينة', value: 'لوريم'),
            PersonalDataFieldWidget(label: 'السن', value: '34'),
          ],
        ),
      ],
    );
  }
}
