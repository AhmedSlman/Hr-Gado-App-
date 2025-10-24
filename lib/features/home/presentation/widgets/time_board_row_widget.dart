import 'package:flutter/material.dart';
import 'package:hr_app/features/home/presentation/widgets/time_board_item_widget.dart';

class TimeBoardRowWidget extends StatelessWidget {
  const TimeBoardRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [TimeBoardWidget(), TimeBoardWidget()]);
  }
}
