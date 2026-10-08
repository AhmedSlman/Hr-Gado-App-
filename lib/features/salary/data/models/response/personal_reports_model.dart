import 'api_values.dart';
import 'salary_model.dart';

class PersonalReport {
  final int id;
  final String date;
  final Map<String, String> metrics;
  const PersonalReport({
    required this.id,
    required this.date,
    required this.metrics,
  });

  factory PersonalReport.fromJson(
    Map<String, dynamic> json,
    EmployeeType type,
  ) {
    final keys = switch (type) {
      EmployeeType.driver => [
        'installation_devices',
        'supply_devices',
        'overtime_hours',
      ],
      EmployeeType.sales => [
        'sold_devices',
        'bought_devices',
        'commercial_devices',
      ],
      EmployeeType.technician => ['num_of_devices', 'num_of_meters'],
      _ => ['overtime_hours'],
    };
    return PersonalReport(
      id: apiCount(json['id']),
      date: json['date']?.toString() ?? '',
      metrics: {
        for (final key in keys)
          key: json[key] == null
              ? '—'
              : key.contains('devices')
              ? apiCount(json[key]).toString()
              : formatSalaryNumber(apiNumber(json[key])),
      },
    );
  }
}

class PersonalReportsResponse {
  final List<PersonalReport> reports;
  const PersonalReportsResponse(this.reports);
  factory PersonalReportsResponse.fromJson(
    Map<String, dynamic> json,
    EmployeeType type,
  ) => PersonalReportsResponse(
    (json['data'] as List? ?? [])
        .map(
          (item) =>
              PersonalReport.fromJson(Map<String, dynamic>.from(item), type),
        )
        .toList(),
  );
}

class ReportFilters {
  final int? month;
  final int? year;
  const ReportFilters({this.month, this.year});
  Map<String, dynamic> toQuery() {
    if (month != null && (month! < 1 || month! > 12)) {
      throw ArgumentError.value(month, 'month', 'Must be 1–12');
    }
    if (year != null && (year! < 2020 || year! > 2030)) {
      throw ArgumentError.value(year, 'year', 'Must be 2020–2030');
    }
    return {if (month != null) 'month': month, if (year != null) 'year': year};
  }
}
