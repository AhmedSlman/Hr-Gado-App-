/// نموذج استجابة تسجيل الحضور
class AttendanceResponseModel {
  final String key;
  final String msg;
  final dynamic data; // يمكن أن يكون String أو List

  const AttendanceResponseModel({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    // التحقق من نوع data والتعامل معه
    dynamic dataValue = json['data'];

    // إذا كان String أو null، نتركه كما هو
    // إذا كان List، نستخدمه مباشرة
    // إذا كان null، نستخدم null أو String فارغ
    if (dataValue == null) {
      dataValue = null;
    } else if (dataValue is String) {
      // نتركه كـ String
    } else if (dataValue is List) {
      // نستخدمه كـ List
    } else {
      // في حالة أي نوع آخر، نحوله إلى String
      dataValue = dataValue.toString();
    }

    return AttendanceResponseModel(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: dataValue,
    );
  }

  bool get isSuccess => key == 'success';

  // Helper methods للحصول على البيانات بشكل آمن
  String get dataAsString =>
      data is String ? data as String : (data?.toString() ?? '');
  List<dynamic> get dataAsList => data is List ? data as List<dynamic> : [];
}

/// نموذج طلب تسجيل الحضور
