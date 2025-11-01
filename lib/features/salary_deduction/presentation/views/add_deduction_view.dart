import 'package:flutter/material.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../components/add_deduction_body_section.dart';

class AddDeductionView extends StatelessWidget {
  const AddDeductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
          child: Column(
            children: const [
              CustomAppBar(title: "اضافة جزاء"),
              Expanded(child: AddDeductionBodySection()),
            ],
          ),
        ),
    
    );
  }
}
