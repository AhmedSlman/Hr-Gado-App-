import 'package:flutter/material.dart';
import '../../data/models/response/salary_model.dart';
import '../../data/models/response/api_values.dart';

class NetMonthlySalary extends StatelessWidget {
  final SalarySummaryData salaryData;
  const NetMonthlySalary({super.key, required this.salaryData});
  @override
  Widget build(BuildContext context) {
    final manager = salaryData.employeeType == EmployeeType.manager;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'صافي الراتب الشهري: ${formatSalaryNumber(salaryData.netMonthlySalary)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            if (manager)
              Text(
                'إجمالي البدلات: ${formatSalaryNumber(salaryData.totalAllowances, cents: true)}',
              )
            else
              Text(
                'إجمالي الحوافز: ${formatSalaryNumber(salaryData.totalBonuses)}',
              ),
            Text(
              'إجمالي الحسومات: ${formatSalaryNumber(salaryData.totalDeductions)}',
            ),
            Text(
              'خصم التأمين: ${formatSalaryNumber(salaryData.insuranceDeduction)}',
            ),
          ],
        ),
        if (manager)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'يشمل الراتب الشهر الحالي كاملاً. قد يختلف الراتب الأساسي اليومي بمقدار قرش بين الأيام.',
            ),
          ),
      ],
    );
  }
}
