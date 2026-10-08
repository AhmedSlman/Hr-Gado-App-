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
    );
  }

  /// Get employee name (from nested or flat)
  String get employeeName => employee?.name ?? name ?? '';

  /// Get employee image (from nested or flat)
  String get employeeImage => employee?.image ?? image ?? '';

  /// Get employee job (from nested or flat)
  String get employeeJob => employee?.job ?? job ?? '';

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
