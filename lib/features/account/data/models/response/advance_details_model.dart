import 'employee_model_simple.dart';

class AdvanceStats {
  final String latestAdvanceDate;

  const AdvanceStats({required this.latestAdvanceDate});

  factory AdvanceStats.fromJson(Map<String, dynamic> json) {
    return AdvanceStats(
      latestAdvanceDate: (json['latest_advance_date'] ?? '').toString(),
    );
  }
}

class AdvanceDetailsModel {
  final int id;
  final String type; // 'normal' or 'long_term'
  final String typeName;
  final int amount;
  final int? numberOfMonths; // Only for long_term
  final EmployeeModelSimple employee;
  final AdvanceStats? stats; // Only for normal advance

  const AdvanceDetailsModel({
    required this.id,
    required this.type,
    required this.typeName,
    required this.amount,
    this.numberOfMonths,
    required this.employee,
    this.stats,
  });

  factory AdvanceDetailsModel.fromJson(Map<String, dynamic> json) {
    final employeeJson = (json['employee'] ?? {}) as Map<String, dynamic>;
    final employee = EmployeeModelSimple.fromJson(employeeJson);

    AdvanceStats? stats;
    if (json['stats'] != null) {
      final statsJson = (json['stats'] ?? {}) as Map<String, dynamic>;
      stats = AdvanceStats.fromJson(statsJson);
    }

    return AdvanceDetailsModel(
      id: (json['id'] ?? 0) as int,
      type: (json['type'] ?? '').toString(),
      typeName: (json['type_name'] ?? '').toString(),
      amount: (json['amount'] ?? 0) as int,
      numberOfMonths: json['number_of_months'] as int?,
      employee: employee,
      stats: stats,
    );
  }
}
