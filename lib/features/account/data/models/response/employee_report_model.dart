/// Employee Report Model
/// Supports different report types:
/// - Type 1: num_of_devices + overtime_hours
/// - Type 2: sold_devices + bought_devices + commercial_devices
/// - Type 3: num_of_devices + num_of_meters
class EmployeeReportModel {
  final int id;
  final String date;
  final int employeeId;
  final String name;
  
  // Type 1 fields
  final int? numOfDevices;
  final int? overtimeHours;
  
  // Type 2 fields
  final int? soldDevices;
  final int? boughtDevices;
  final int? commercialDevices;
  
  // Type 3 fields
  final int? numOfMeters;

  const EmployeeReportModel({
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
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '').toString(),
      employeeId: (json['employee_id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      numOfDevices: json['num_of_devices'] as int?,
      overtimeHours: json['overtime_hours'] as int?,
      soldDevices: json['sold_devices'] as int?,
      boughtDevices: json['bought_devices'] as int?,
      commercialDevices: json['commercial_devices'] as int?,
      numOfMeters: json['num_of_meters'] as int?,
    );
  }

  /// Check if this is a Type 1 report (devices + overtime)
  bool get isType1 => numOfDevices != null && overtimeHours != null;

  /// Check if this is a Type 2 report (sold/bought/commercial devices)
  bool get isType2 =>
      soldDevices != null &&
      boughtDevices != null &&
      commercialDevices != null;

  /// Check if this is a Type 3 report (devices + meters)
  bool get isType3 => numOfDevices != null && numOfMeters != null;

  /// Get the display value for number of devices (for UI)
  String? get displayDevices => numOfDevices?.toString();

  /// Get the display value for meters (for UI)
  String? get displayMeters => numOfMeters?.toString();
}

