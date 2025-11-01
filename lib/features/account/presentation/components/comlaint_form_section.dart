import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/features/account/presentation/widgets/complaints_text_field.dart';

class ComplaintFormSection extends StatelessWidget {
  ComplaintFormSection({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ComlaintsTextFormField(controller: _controller),
          SizedBox(height: 32.h),
          // Send button
          CustomButton(
            text: 'ارسال',
            onPressed: () {
              // Handle send
            },
            height: 50.h,
          ),
        ],
      ),
    );
  }
}
