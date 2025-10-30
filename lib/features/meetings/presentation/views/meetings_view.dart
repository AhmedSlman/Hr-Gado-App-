import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/meetings/presentation/components/meetings_body_section.dart';

class MeetingsView extends StatelessWidget {
  const MeetingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "الاجتماعات"),
            Expanded(child: MeetingsBodySection()),
          ],
        ),
      ),
    );
  }
}
