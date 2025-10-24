class UserModel {
  final int id;
  final String role;
  final String job;
  final String jobType;
  final String image;
  final String token;

  const UserModel({
    required this.id,
    required this.role,
    required this.job,
    required this.jobType,
    required this.image,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    role: json['role'] ?? '',
    job: json['job'] ?? '',
    jobType: json['job_type'] ?? '',
    image: json['image'] ?? '',
    token: json['token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'job': job,
    'job_type': jobType,
    'image': image,
    'token': token,
  };
}
