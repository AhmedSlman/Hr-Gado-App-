class EmployeeModel {
  final int id;
  final String name;
  final String job;
  final String image;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.job,
    required this.image,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      job: (json['job'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }
}

