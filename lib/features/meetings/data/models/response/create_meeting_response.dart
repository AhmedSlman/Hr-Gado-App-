class CreateMeetingResponse {
  final String key;
  final String msg;
  final List<dynamic> data;

  const CreateMeetingResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CreateMeetingResponse.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?) ?? <dynamic>[],
    );
  }

  bool get isSuccess => key == 'success';
}
