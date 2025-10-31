class CreateNewsRequest {
  final String title;
  final String content;
  final int aboutEmployee; // 0 or 1
  final int? employeeId; // only if aboutEmployee == 1
  final int durationInDays;

  const CreateNewsRequest({
    required this.title,
    required this.content,
    required this.aboutEmployee,
    this.employeeId,
    required this.durationInDays,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'content': content,
      'about_employee': aboutEmployee,
      'duration_in_days': durationInDays,
    };

    if (aboutEmployee == 1 && employeeId != null) {
      json['employee_id'] = employeeId;
    }

    return json;
  }
}
