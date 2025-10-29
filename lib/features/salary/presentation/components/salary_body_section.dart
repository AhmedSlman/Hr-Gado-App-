import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/salary/logic/salary_cubit.dart';
import 'package:hr_app/features/salary/logic/salary_states.dart';
import 'package:hr_app/features/salary/presentation/components/daily_summay_list.dart';
import 'package:hr_app/features/salary/presentation/widgets/balance_summary_widgets.dart';

import '../widgets/net_monthly_salary.dart';

class SalaryBodySection extends StatelessWidget {
  const SalaryBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryCubit, SalaryStates>(
      builder: (context, state) {
        if (state is SalaryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SalaryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    SalaryCubit.get(context).getMySalarySummary();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is SalarySuccess) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Balance Summary Widget (includes date and salary info)
                  BalanceSummaryWidgets(salaryData: state.salarySummary.data),

                  const SizedBox(height: 24),
                  Divider(color: AppColors.primary),

                  // Main Balance Card
                  NetMonthlySalary(salaryData: state.salarySummary.data),

                  const SizedBox(height: 24),

                  // Transactions List
                  DailySummaryList(
                    salaryHistory: state.salarySummary.data.salaryHistory,
                    employeeType: state.salarySummary.data.employeeType,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
