class PersonalDataModel {
  final int id;
  final String name;
  final String job;
  final String phone;
  final String city;
  final int age;
  final String image;
  final List<String> papers;

  const PersonalDataModel({
    required this.id,
    required this.name,
    required this.job,
    required this.phone,
    required this.city,
    required this.age,
    required this.image,
    required this.papers,
  });

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    final papersList = (json['papers'] ?? []) as List;
    final papers = papersList.map((e) => e.toString()).toList();

    return PersonalDataModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      job: (json['job'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      age: (json['age'] ?? 0) as int,
      image: (json['image'] ?? '').toString(),
      papers: papers,
    );
  }
}
