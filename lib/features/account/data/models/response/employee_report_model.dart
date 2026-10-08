import '../../../../salary/data/models/response/api_values.dart';
import '../../../../salary/data/models/response/report_metrics.dart';

/// Employee Report Model
/// Supports different report types:
/// - Type 1: num_of_devices + overtime_hours
/// - Type 2: sold_devices + bought_devices + commercial_devices
/// - Type 3: num_of_devices + num_of_meters
class EmployeeReportModel {
  final Map<String, num?> metrics;
  final int? installationDevices;
  final int? supplyDevices;
  final int id;
  final String date;
  final int employeeId;
  final String name;

  // Type 1 fields
  final int? numOfDevices;
  final double? overtimeHours;

  // Type 2 fields
  final int? soldDevices;
  final int? boughtDevices;
  final int? commercialDevices;

  // Type 3 fields
  final double? numOfMeters;

  const EmployeeReportModel({
    this.metrics = const {},
    this.installationDevices,
    this.supplyDevices,
    required this.id,
    required this.date,
    required this.employeeId,
    required this.name,
    this.numOfDevices,
    this.overtimeHours,
    this.soldDevices,
    this.boughtDevices,
    this.commercialDevices,
    this.numOfMeters,
  });

  factory EmployeeReportModel.fromJson(Map<String, dynamic> json) {
    return EmployeeReportModel(
      metrics: readReportMetrics(json),
      installationDevices: json['installation_devices'] == null
          ? null
          : apiCount(json['installation_devices']),
      supplyDevices: json['supply_devices'] == null
          ? null
          : apiCount(json['supply_devices']),
      id: apiCount(json['id']),
      date: (json['date'] ?? '').toString(),
      employeeId: (json['employee_id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      numOfDevices: json['num_of_devices'] == null
          ? null
          : apiCount(json['num_of_devices']),
      overtimeHours: json['overtime_hours'] == null
          ? null
          : apiNumber(json['overtime_hours']),
      soldDevices: json['sold_devices'] == null
          ? null
          : apiCount(json['sold_devices']),
      boughtDevices: json['bought_devices'] == null
          ? null
          : apiCount(json['bought_devices']),
      commercialDevices: json['commercial_devices'] == null
          ? null
          : apiCount(json['commercial_devices']),
      numOfMeters: json['num_of_meters'] == null
          ? null
          : apiNumber(json['num_of_meters']),
    );
  }

  /// Check if this is a Type 1 report (devices + overtime)
  bool get isType1 => numOfDevices != null && overtimeHours != null;

  /// Check if this is a Type 2 report (sold/bought/commercial devices)
  bool get isType2 =>
      soldDevices != null && boughtDevices != null && commercialDevices != null;

  /// Check if this is a Type 3 report (devices + meters)
  bool get isType3 => numOfDevices != null && numOfMeters != null;

  /// Get the display value for number of devices (for UI)
  String? get displayDevices => numOfDevices?.toString();

  /// Get the display value for meters (for UI)
  String? get displayMeters => numOfMeters?.toString();
}
