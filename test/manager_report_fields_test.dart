import 'package:flutter_test/flutter_test.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/salary/data/models/response/report_metrics.dart';

void main() {
  final variants = {
    'driver': ['installation_devices', 'supply_devices', 'overtime_hours'],
    'technician': ['num_of_devices', 'num_of_meters'],
    'sales': ['sold_devices', 'bought_devices', 'commercial_devices'],
    'other': ['overtime_hours'],
  };
  for (final variant in variants.entries) {
    test(
      '${variant.key} ignores unrelated API metrics and includes missing fields',
      () {
        final report = EmployeeReportDetailsModel.fromJson({
          'employee': {'job_type': variant.key, 'job': 'Custom job title'},
          for (final key in reportMetricKeys) key: null,
        });
        expect(report.editableMetricKeys, variant.value);
        final missingMetrics = EmployeeReportDetailsModel.fromJson({
          'job_type': variant.key,
        });
        expect(missingMetrics.editableMetricKeys, variant.value);
      },
    );
  }
  test('legacy reports recover their variant from non-null metrics', () {
    final report = EmployeeReportDetailsModel.fromJson({
      for (final key in reportMetricKeys) key: null,
      'num_of_devices': 0,
      'num_of_meters': 2.5,
    });
    expect(report.editableMetricKeys, variants['technician']);
    expect(report.metrics['num_of_meters'], 2.5);
  });
}
