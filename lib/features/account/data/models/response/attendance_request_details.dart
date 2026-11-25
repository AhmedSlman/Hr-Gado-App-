class AttendanceRequestDetails {
  final String employeeName;
  final String date;
  final String typeName;
  final int durationMinutes;
  final int status;
  final String statusName;

  const AttendanceRequestDetails({
    required this.employeeName,
    required this.date,
    required this.typeName,
    required this.durationMinutes,
    required this.status,
    required this.statusName,
  });

  factory AttendanceRequestDetails.fromJson(Map<String, dynamic> json) {
    return AttendanceRequestDetails(
      employeeName: json['employee_name'] as String,
      date: json['date'] as String,
      typeName: json['type_name'] as String,
      durationMinutes: json['duration_minutes'] as int,
      status: json['status'] as int,
      statusName: json['status_name'] as String,
    );
  }

  bool get isPending => status == 0;
}
