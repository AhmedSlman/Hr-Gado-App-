class CreateDeductionResponse {
  final String key;
  final String msg;
  final List<dynamic> data;

  const CreateDeductionResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CreateDeductionResponse.fromJson(Map<String, dynamic> json) {
    return CreateDeductionResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data};
  }
}
