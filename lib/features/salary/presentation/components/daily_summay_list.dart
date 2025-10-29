import 'package:flutter/material.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';
import 'package:hr_app/features/salary/presentation/widgets/salary_transaction_card.dart';

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: salaryHistory.length,
      itemBuilder: (context, index) {
        final item = salaryHistory[index];

        // Parse salary text to extract amount and badge info
        final salaryInfo = _parseSalaryText(item.salaryText);

        // Extract metrics values based on employee type
        final metricsData = _extractMetricsData(item.metrics, employeeType);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < salaryHistory.length - 1 ? 12 : 0,
          ),
          child: SalaryTransactionCard(
            date: item.date,
            metricsData: metricsData,
            salary: salaryInfo['amount'],
            badgeText: salaryInfo['badgeText'],
            badgeColor: salaryInfo['badgeColor'],
            hasReport: item.hasReport,
            employeeType: employeeType,
            reportId: item.reportId,
          ),
        );
      },
    );
  }

  Map<String, String> _extractMetricsData(
    SalaryMetrics metrics,
    EmployeeType type,
  ) {
    switch (type) {
      case EmployeeType.driver:
        final driverMetrics = metrics as DriverMetrics;
        return {
          'meters': driverMetrics.overtimeHours.toString(),
          'devices': driverMetrics.devices.toString(),
        };

      case EmployeeType.sales:
        final salesMetrics = metrics as SalesMetrics;
        return {
          'sold_devices': salesMetrics.soldDevices.toString(),
          'bought_devices': salesMetrics.boughtDevices.toString(),
          'commercial_devices': salesMetrics.commercialDevices.toString(),
        };

      case EmployeeType.technician:
        final techMetrics = metrics as TechnicianMetrics;
        return {
          'meters': techMetrics.meters.toString(),
          'devices': techMetrics.devices.toString(),
        };

      case EmployeeType.other:
        final otherMetrics = metrics as OtherMetrics;
        return {'overtime_hours': otherMetrics.overtimeHours.toString()};
    }
  }

  Map<String, dynamic> _parseSalaryText(String salaryText) {
    // Parse salary text like "273.33 خصم (273.33)" or "273.00"
    final parts = salaryText.split(' ');
    final amount = parts.isNotEmpty ? parts[0] : '0';

    String? badgeText;
    Color? badgeColor;

    if (salaryText.contains('خصم')) {
      badgeText = 'خصم';
      badgeColor = Colors.red;
    } else if (salaryText.contains('حافز')) {
      badgeText = 'حافز';
      badgeColor = Colors.green;
    }

    return {'amount': amount, 'badgeText': badgeText, 'badgeColor': badgeColor};
  }
}
