import 'api_values.dart';

const reportMetricKeys = [
  'installation_devices',
  'supply_devices',
  'num_of_devices',
  'num_of_meters',
  'overtime_hours',
  'sold_devices',
  'bought_devices',
  'commercial_devices',
];

Map<String, num?> readReportMetrics(Map<String, dynamic> json) => {
  for (final key in reportMetricKeys)
    if (json.containsKey(key))
      key: json[key] == null
          ? null
          : key.contains('devices')
          ? apiCount(json[key])
          : apiNumber(json[key]),
};

Map<String, String> displayReportMetrics(Map<String, num?> metrics) => {
  for (final entry in metrics.entries)
    entry.key: entry.value == null
        ? '—'
        : formatSalaryNumber(entry.value!.toDouble()),
};
