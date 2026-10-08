double apiNumber(dynamic value) {
  if (value == null) return 0;
  final number = value is num ? value.toDouble() : double.tryParse('$value');
  if (number == null || !number.isFinite) {
    throw FormatException('Invalid numeric API value: $value');
  }
  return number;
}

int apiCount(dynamic value) {
  final number = apiNumber(value);
  if (number < 0 || number != number.truncateToDouble()) {
    throw FormatException('Invalid device count: $value');
  }
  return number.toInt();
}

String formatSalaryNumber(double value, {bool cents = false}) =>
    cents || value != value.truncateToDouble()
    ? value.toStringAsFixed(2)
    : value.toStringAsFixed(0);

Map<String, dynamic> apiMetrics(dynamic value) {
  if (value == null || (value is List && value.isEmpty)) return {};
  if (value is Map) return Map<String, dynamic>.from(value);
  throw const FormatException('Expected report metrics object or empty array');
}
