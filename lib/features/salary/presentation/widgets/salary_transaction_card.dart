import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/response/salary_model.dart';
import '../../logic/salary_cubit.dart';
import '../../router/salary_names.dart';
import 'report_metric_labels.dart';

class SalaryTransactionCard extends StatelessWidget {
  final String date;
  final Map<String, String> metricsData;
  final String salary;
  final bool hasReport;
  final EmployeeType employeeType;
  final int? reportId;
  const SalaryTransactionCard({
    super.key,
    required this.date,
    required this.metricsData,
    required this.salary,
    this.hasReport = false,
    required this.employeeType,
    this.reportId,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(date, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(salary, style: Theme.of(context).textTheme.titleMedium),
          if (employeeType != EmployeeType.manager &&
              metricsData.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                for (final entry in metricsData.entries)
                  Text(
                    '${reportMetricLabels[entry.key] ?? entry.key}: ${entry.value}',
                  ),
              ],
            ),
          ],
          if (employeeType != EmployeeType.manager &&
              hasReport &&
              reportId != null)
            TextButton(
              onPressed: () async {
                final cubit = SalaryCubit.get(context);
                await context.push(
                  SalaryRoutes.reportDetails,
                  extra: {
                    'reportId': reportId,
                    'metricsData': metricsData,
                    'date': date,
                  },
                );
                if (!cubit.isClosed) await cubit.getMySalarySummary();
              },
              child: const Text('عرض تفاصيل التقرير'),
            ),
        ],
      ),
    ),
  );
}
