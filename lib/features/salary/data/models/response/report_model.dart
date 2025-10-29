class ReportData {
  final int id;
  final String date;
  final String content;
  final String addition;
  final String additionTarget;

  const ReportData({
    required this.id,
    required this.date,
    required this.content,
    required this.addition,
    required this.additionTarget,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      content: json['content'] ?? '',
      addition: json['addition'] ?? '',
      additionTarget: json['addition_target'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'content': content,
      'addition': addition,
      'addition_target': additionTarget,
    };
  }
}

class ReportResponse {
  final String key;
  final String msg;
  final ReportData data;

  const ReportResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: ReportData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data.toJson()};
  }
}
