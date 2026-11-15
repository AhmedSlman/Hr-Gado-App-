import '../../../../salary/data/models/response/api_values.dart';
import '../../../../salary/data/models/response/report_metrics.dart';
import 'employee_model_simple.dart';

class EmployeeReportDetailsModel {
  final Map<String, num?> metrics;
  final int? installationDevices;
  final int? supplyDevices;
  final int id;
  final String date;
  final String content;

  // Type 1 fields (devices + overtime)
  final int? numOfDevices;
  final double? overtimeHours;

  // Type 2 fields (alternative format)
  final String? addition;
  final double? additionOvertime;

  // Type 2 fields (sold/bought/commercial)
  final int? soldDevices;
  final int? boughtDevices;
  final int? commercialDevices;

  // Type 3 fields (devices + meters)
  final double? numOfMeters;

  // Employee info (can be nested or flat)
  final EmployeeModelSimple? employee;
  final String? name;
  final String? image;
  final String? job;
  final String? jobType;

  const EmployeeReportDetailsModel({
    this.metrics = const {},
    this.installationDevices,
    this.supplyDevices,
    required this.id,
    required this.date,
    required this.content,
    this.numOfDevices,
    this.overtimeHours,
    this.addition,
    this.additionOvertime,
    this.soldDevices,
    this.boughtDevices,
    this.commercialDevices,
    this.numOfMeters,
    this.employee,
    this.name,
    this.image,
    this.job,
    this.jobType,
  });

  factory EmployeeReportDetailsModel.fromJson(Map<String, dynamic> json) {
    // Handle nested employee object
    EmployeeModelSimple? employeeObj;
    if (json['employee'] != null) {
      employeeObj = EmployeeModelSimple.fromJson(
        json['employee'] as Map<String, dynamic>,
      );
    }

    // Handle flat employee fields
    final employeeName = employeeObj?.name ?? json['name'] as String?;
    final employeeImage = employeeObj?.image ?? json['image'] as String?;
    final employeeJob = employeeObj?.job ?? json['job'] as String?;

    return EmployeeReportDetailsModel(
      metrics: readReportMetrics(json),
      installationDevices: json['installation_devices'] == null
          ? null
          : apiCount(json['installation_devices']),
      supplyDevices: json['supply_devices'] == null
          ? null
          : apiCount(json['supply_devices']),
      id: apiCount(json['id']),
      date: (json['date'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      numOfDevices: json['num_of_devices'] == null
          ? null
          : apiCount(json['num_of_devices']),
      overtimeHours: json['overtime_hours'] == null
          ? null
          : apiNumber(json['overtime_hours']),
      addition: json['addition'] as String?,
      additionOvertime: json['addition_overtime'] == null
          ? null
          : apiNumber(json['addition_overtime']),
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
      employee: employeeObj,
      name: employeeName,
      image: employeeImage,
      job: employeeJob,
      jobType:
          (json['employee'] is Map
                  ? json['employee']['job_type'] ?? json['job_type']
                  : json['job_type'])
              ?.toString(),
    );
  }

  /// Get employee name (from nested or flat)
  String get employeeName => employee?.name ?? name ?? '';

  /// Get employee image (from nested or flat)
  String get employeeImage => employee?.image ?? image ?? '';

  /// Get employee job (from nested or flat)
  String get employeeJob => employee?.job ?? job ?? '';

  /// Match the fields in the employee's daily report form.
  List<String> get editableMetricKeys {
    final type = (jobType ?? employeeJob).trim().toLowerCase();
    switch (type) {
      case 'driver':
      case 'سائق':
        return ['installation_devices', 'supply_devices', 'overtime_hours'];
      case 'technician':
      case 'فني':
        return ['num_of_devices', 'num_of_meters'];
      case 'sales':
      case 'مبيعات':
        return ['sold_devices', 'bought_devices', 'commercial_devices'];
      default:
        // Older responses may omit the employee type. Ignore unrelated null
        // metrics when recovering the report variant from its saved values.
        if (type.isEmpty) {
          if ([
            'installation_devices',
            'supply_devices',
          ].any((key) => metrics[key] != null)) {
            return ['installation_devices', 'supply_devices', 'overtime_hours'];
          }
          if ([
            'sold_devices',
            'bought_devices',
            'commercial_devices',
          ].any((key) => metrics[key] != null)) {
            return ['sold_devices', 'bought_devices', 'commercial_devices'];
          }
          if ([
            'num_of_devices',
            'num_of_meters',
          ].any((key) => metrics[key] != null)) {
            return ['num_of_devices', 'num_of_meters'];
          }
        }
        return ['overtime_hours'];
    }
  }

  /// Get display value for devices
  String? get displayDevices => numOfDevices?.toString();

  /// Get display value for meters
  String? get displayMeters => numOfMeters?.toString();

  /// Get display value for hours (overtime or addition_overtime)
  String? get displayHours {
    if (overtimeHours != null) {
      return overtimeHours.toString();
    }
    if (additionOvertime != null) {
      return additionOvertime.toString();
    }
    return null;
  }
}
