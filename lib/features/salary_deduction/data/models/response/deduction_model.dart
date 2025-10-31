class DeductionEmployee {
  final String name;
  final String job;

  const DeductionEmployee({required this.name, required this.job});

  factory DeductionEmployee.fromJson(Map<String, dynamic> json) {
    return DeductionEmployee(name: json['name'] ?? '', job: json['job'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'job': job};
  }
}

class DeductionModel {
  final int id;
  final String date;
  final int amount;
  final String type;
  final DeductionEmployee? employee; // Optional - موجود في response المدير فقط

  const DeductionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    this.employee,
  });

  factory DeductionModel.fromJson(Map<String, dynamic> json) {
    return DeductionModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      amount: json['amount'] ?? 0,
      type: json['type'] ?? '',
      employee: json['employee'] != null
          ? DeductionEmployee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'type': type,
      if (employee != null) 'employee': employee!.toJson(),
    };
  }
}

class DeductionsResponse {
  final String key;
  final String msg;
  final List<DeductionModel> data;

  const DeductionsResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory DeductionsResponse.fromJson(Map<String, dynamic> json) {
    return DeductionsResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => DeductionModel.fromJson(e as Map<String, dynamic>))
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
