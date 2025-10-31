class CreateCarResponse {
  final String key;
  final String msg;
  final List<dynamic> data;

  const CreateCarResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CreateCarResponse.fromJson(Map<String, dynamic> json) {
    return CreateCarResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data};
  }
}
