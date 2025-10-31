class CreateNewsResponse {
  final String key;
  final String msg;
  final List<dynamic> data;

  const CreateNewsResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CreateNewsResponse.fromJson(Map<String, dynamic> json) {
    return CreateNewsResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: (json['data'] as List<dynamic>?) ?? <dynamic>[],
    );
  }

  bool get isSuccess => key == 'success';
}
