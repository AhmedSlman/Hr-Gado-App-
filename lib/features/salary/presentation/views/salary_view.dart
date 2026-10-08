import 'package:go_router/go_router.dart';
import '../../router/salary_names.dart';
import '../../logic/salary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/salary/presentation/components/salary_body_section.dart';

class SalaryView extends StatelessWidget {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "رصيدك من الراتب"),
            TextButton(
              onPressed: () async {
                final cubit = SalaryCubit.get(context);
                await context.push(SalaryRoutes.personalReports);
                if (!cubit.isClosed) await cubit.getMySalarySummary();
              },
              child: const Text('تقاريري المؤكدة'),
            ),
            const Expanded(child: SalaryBodySection()),
          ],
        ),
      ),
    );
  }
}
