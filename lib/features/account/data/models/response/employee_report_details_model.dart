import 'employee_model_simple.dart';

class EmployeeReportDetailsModel {
  final int id;
  final String date;
  final String content;

  // Type 1 fields (devices + overtime)
  final int? numOfDevices;
  final int? overtimeHours;

  // Type 2 fields (alternative format)
  final String? addition;
  final int? additionOvertime;

  // Type 2 fields (sold/bought/commercial)
  final int? soldDevices;
  final int? boughtDevices;
  final int? commercialDevices;

  // Type 3 fields (devices + meters)
  final int? numOfMeters;

  // Employee info (can be nested or flat)
  final EmployeeModelSimple? employee;
  final String? name;
  final String? image;
  final String? job;

  const EmployeeReportDetailsModel({
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
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      numOfDevices: json['num_of_devices'] as int?,
      overtimeHours: json['overtime_hours'] as int?,
      addition: json['addition'] as String?,
      additionOvertime: json['addition_overtime'] as int?,
      soldDevices: json['sold_devices'] as int?,
      boughtDevices: json['bought_devices'] as int?,
      commercialDevices: json['commercial_devices'] as int?,
      numOfMeters: json['num_of_meters'] as int?,
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
