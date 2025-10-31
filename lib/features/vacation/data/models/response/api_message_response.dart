class ApiMessageResponse {
  final String key;
  final String msg;
  final dynamic data;

  const ApiMessageResponse({required this.key, required this.msg, this.data});

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) {
    return ApiMessageResponse(
      key: (json['key'] ?? '').toString(),
      msg: (json['msg'] ?? '').toString(),
      data: json['data'],
    );
  }
}
