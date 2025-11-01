import 'employee_model_simple.dart';

class VacationStats {
  final int allowedOffDays;
  final int usedOffDays;
  final int remainingOffDays;

  const VacationStats({
    required this.allowedOffDays,
    required this.usedOffDays,
    required this.remainingOffDays,
  });

  factory VacationStats.fromJson(Map<String, dynamic> json) {
    return VacationStats(
      allowedOffDays: (json['allowed_off_days'] ?? 0) as int,
      usedOffDays: (json['used_off_days'] ?? 0) as int,
      remainingOffDays: (json['remaining_off_days'] ?? 0) as int,
    );
  }
}

class VacationDetailsModel {
  final int id;
  final String startDate;
  final String endDate;
  final int numberOfDays;
  final EmployeeModelSimple employee;
  final VacationStats stats;

  const VacationDetailsModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.employee,
    required this.stats,
  });

  factory VacationDetailsModel.fromJson(Map<String, dynamic> json) {
    final employeeJson = (json['employee'] ?? {}) as Map<String, dynamic>;
    final employee = EmployeeModelSimple.fromJson(employeeJson);

    final statsJson = (json['stats'] ?? {}) as Map<String, dynamic>;
    final stats = VacationStats.fromJson(statsJson);

    return VacationDetailsModel(
      id: (json['id'] ?? 0) as int,
      startDate: (json['start_date'] ?? '').toString(),
      endDate: (json['end_date'] ?? '').toString(),
      numberOfDays: (json['number_of_days'] ?? 0) as int,
      employee: employee,
      stats: stats,
    );
  }
}

