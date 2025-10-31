class EmployeeInfo {
  final String name;
  final String image;
  final String jobTitle;

  const EmployeeInfo({
    required this.name,
    required this.image,
    required this.jobTitle,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      jobTitle: json['job_title'] ?? '',
    );
  }
}

class NewsModel {
  final int id;
  final String title;
  final String content;
  final int aboutEmployee; // 0 or 1
  final EmployeeInfo? employee;

  const NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.aboutEmployee,
    this.employee,
  });

  bool get isAboutEmployee => aboutEmployee == 1;

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      aboutEmployee: json['about_employee'] ?? 0,
      employee: json['employee'] != null
          ? EmployeeInfo.fromJson(json['employee'])
          : null,
    );
  }
}
