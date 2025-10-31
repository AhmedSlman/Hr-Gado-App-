import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/news/presentation/components/add_news_body_section.dart';

class AddNewsView extends StatelessWidget {
  const AddNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "اضافة خبر"),
            Expanded(child: AddNewsBodySection()),
          ],
        ),
      ),
    );
  }
}
