class EmployeeData {
  final int id;
  final String name;
  final String job;
  final String image;

  const EmployeeData({
    required this.id,
    required this.name,
    required this.job,
    required this.image,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'job': job, 'image': image};
  }
}

class EmployeesResponse {
  final String key;
  final String msg;
  final List<EmployeeData> data;

  const EmployeesResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    return EmployeesResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => EmployeeData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'msg': msg,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
