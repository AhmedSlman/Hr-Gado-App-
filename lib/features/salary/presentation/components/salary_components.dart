import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/salary_cubit.dart';
import '../widgets/salary_widgets.dart';

class SalaryHeaderSection extends StatelessWidget {
  const SalaryHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SalaryHeaderWidget(title: runtimeType.toString());
  }
}

class SalaryBodySection extends StatelessWidget {
  const SalaryBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
