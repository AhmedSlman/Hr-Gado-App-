class EmployeeModelSimple {
  final int id;
  final String name;
  final String image;
  final String job;

  const EmployeeModelSimple({
    required this.id,
    required this.name,
    required this.image,
    required this.job,
  });

  factory EmployeeModelSimple.fromJson(Map<String, dynamic> json) {
    return EmployeeModelSimple(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      job: (json['job'] ?? '').toString(),
    );
  }
}
