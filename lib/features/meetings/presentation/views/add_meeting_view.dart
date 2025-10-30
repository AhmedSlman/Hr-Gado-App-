import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/meetings/presentation/components/add_meeting_body_section.dart';

class AddMeetingView extends StatelessWidget {
  const AddMeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "اضافة اجتماع"),
            Expanded(child: AddMeetingBodySection()),
          ],
        ),
      ),
    );
  }
}
