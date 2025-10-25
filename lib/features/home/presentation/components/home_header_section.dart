import 'package:flutter/material.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/presentation/widgets/home_header_widget.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeHeaderWidget(
      userName: UserHelper.displayName,
      profileImage: UserHelper.userImage ?? "",
      role: UserHelper.userRole ?? "",
    );
  }
}
