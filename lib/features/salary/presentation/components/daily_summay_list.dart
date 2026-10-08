import 'package:flutter/material.dart';
import '../../data/models/response/salary_model.dart';
import '../../data/models/response/api_values.dart';
import '../widgets/salary_transaction_card.dart';

class DailySummaryList extends StatelessWidget {
  final List<SalaryHistoryItem> salaryHistory;
  final EmployeeType employeeType;
  const DailySummaryList({
    super.key,
    required this.salaryHistory,
    required this.employeeType,
  });

  @override
  Widget build(BuildContext context) {
    if (salaryHistory.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('لا توجد بيانات راتب لهذا الشهر'),
      );
    return Column(
      children: [
        for (final item in salaryHistory)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SalaryTransactionCard(
              date: item.date,
              metricsData: {
                for (final entry in item.metrics.toJson().entries)
                  entry.key: formatSalaryNumber(apiNumber(entry.value)),
              },
              salary: item.salaryText,
              hasReport: item.hasReport,
              employeeType: employeeType,
              reportId: item.reportId,
            ),
          ),
      ],
    );
  }
}
