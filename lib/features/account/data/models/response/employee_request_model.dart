class EmployeeRequestModel {
  final int id;
  final String date;
  final String employeeName;
  final String type; // 'leave' or 'advance'
  final String typeName; // 'طلب إجازة' or 'طلب سلفة'
  final int? numOfDays; // for leave requests
  final int? amount; // for advance requests

  const EmployeeRequestModel({
    required this.id,
    required this.date,
    required this.employeeName,
    required this.type,
    required this.typeName,
    this.numOfDays,
    this.amount,
  });

  factory EmployeeRequestModel.fromJson(Map<String, dynamic> json) {
    return EmployeeRequestModel(
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '').toString(),
      employeeName: (json['employee_name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      typeName: (json['type_name'] ?? '').toString(),
      numOfDays: json['num_of_days'] as int?,
      amount: json['amount'] as int?,
    );
  }

  // Helper to get details string for UI
  String get details {
    if (type == 'leave' && numOfDays != null) {
      return '$numOfDays ايام';
    } else if (type == 'advance' && amount != null) {
      return '$amount ج';
    }
    return '';
  }

  // Helper to get request type enum
  String get requestTypeEnum {
    if (type == 'leave') {
      return 'vacation';
    } else if (type == 'advance') {
      // We'll need to determine if it's normal or long_term based on additional data
      // For now, default to normal_advance
      return 'normal_advance';
    }
    return 'vacation';
  }
}

