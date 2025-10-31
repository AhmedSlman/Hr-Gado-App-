import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/response/car_model.dart';
import '../widgets/car_card.dart';

class CarsList extends StatelessWidget {
  final List<CarListItem> cars;

  const CarsList({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cars.length,
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        return CarCard(car: cars[index]);
      },
    );
  }
}
