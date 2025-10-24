import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/auth/presentation/components/login_section.dart';
import 'package:hr_app/features/auth/presentation/widgets/auth_header_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthHeaderWidget(title: 'تسجيل دخول'),
            SizedBox(height: 20),
            LoginSection(),
          ],
        ),
      ),
    );
  }
}
