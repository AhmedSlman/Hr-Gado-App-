/// نموذج استجابة تسجيل الحضور
class AttendanceResponseModel {
  final String key;
  final String msg;
  final List<dynamic> data;

  const AttendanceResponseModel({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'] ?? [],
    );
  }

  bool get isSuccess => key == 'success';
}

/// نموذج طلب تسجيل الحضور
