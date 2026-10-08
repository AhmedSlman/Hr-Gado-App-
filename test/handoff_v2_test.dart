import 'package:flutter_test/flutter_test.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/home/data/models/response/home_screen_model.dart';
import 'package:hr_app/features/salary/data/models/response/report_metrics.dart';

void main() {
  test(
    'review parses owner metrics independent of manager job and preserves null',
    () {
      final report = EmployeeReportDetailsModel.fromJson({
        'id': 7,
        'date': 'today',
        'content': 'work',
        'installation_devices': '150',
        'supply_devices': null,
        'overtime_hours': '1.5',
        'employee': {'id': 3, 'name': 'Driver', 'image': null, 'job': 'سائق'},
      });
      expect(report.metrics, {
        'installation_devices': 150,
        'supply_devices': null,
        'overtime_hours': 1.5,
      });
      expect(displayReportMetrics(report.metrics)['supply_devices'], '—');
      expect(report.metrics.containsKey('num_of_devices'), false);
    },
  );
  test('home omits salary when no stored salary exists', () {
    expect(HomeScreenData.fromJson({'today': 'today'}).dailySalary, isNull);
  });
  test('home preserves server net salary without recalculating payroll', () {
    final salary = HomeScreenData.fromJson({
      'daily_salary': {
        'base_daily_salary': '387',
        'bonus': '20',
        'deduction': 10,
        'net_amount': '-5',
      },
    }).dailySalary!;
    expect(salary.bonus, 20);
    expect(salary.netAmount, -5);
  });
}
