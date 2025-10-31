import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/cars/presentation/components/car_details_body_section.dart';

class CarDetailsView extends StatelessWidget {
  const CarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            CustomAppBar(title: "تفاصيل السيارة"),
            Expanded(child: CarDetailsBodySection()),
          ],
        ),
      ),
    );
  }
}
