/// نموذج استجابة إرسال التقرير اليومي
class DailyReportResponseModel {
  final String key;
  final String msg;
  final dynamic data; // يمكن أن يكون String أو List أو Object

  const DailyReportResponseModel({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory DailyReportResponseModel.fromJson(Map<String, dynamic> json) {
    return DailyReportResponseModel(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'],
    );
  }

  bool get isSuccess => key == 'success';
}

