class CarListItem {
  final int id;
  final String model;
  final String licensePlate;
  final String licenseRenewal;
  final String nextOilChange;

  const CarListItem({
    required this.id,
    required this.model,
    required this.licensePlate,
    required this.licenseRenewal,
    required this.nextOilChange,
  });

  factory CarListItem.fromJson(Map<String, dynamic> json) {
    return CarListItem(
      id: json['id'] ?? 0,
      model: json['model'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      licenseRenewal: json['license_renewal'] ?? '',
      nextOilChange: json['next_oil_change'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'license_plate': licensePlate,
      'license_renewal': licenseRenewal,
      'next_oil_change': nextOilChange,
    };
  }
}

class CarDetails {
  final int id;
  final String model;
  final String licensePlate;
  final String licenseIssue;
  final String licenseRenewal;
  final String lastOilChange;
  final String nextOilChange;
  final int employeeId;
  final String employeeName;

  const CarDetails({
    required this.id,
    required this.model,
    required this.licensePlate,
    required this.licenseIssue,
    required this.licenseRenewal,
    required this.lastOilChange,
    required this.nextOilChange,
    required this.employeeId,
    required this.employeeName,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      id: json['id'] ?? 0,
      model: json['model'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      licenseIssue: json['license_issue'] ?? '',
      licenseRenewal: json['license_renewal'] ?? '',
      lastOilChange: json['last_oil_change'] ?? '',
      nextOilChange: json['next_oil_change'] ?? '',
      employeeId: json['employee_id'] ?? 0,
      employeeName: json['employee_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'license_plate': licensePlate,
      'license_issue': licenseIssue,
      'license_renewal': licenseRenewal,
      'last_oil_change': lastOilChange,
      'next_oil_change': nextOilChange,
      'employee_id': employeeId,
      'employee_name': employeeName,
    };
  }
}

class CarsListResponse {
  final String key;
  final String msg;
  final List<CarListItem> data;

  const CarsListResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CarsListResponse.fromJson(Map<String, dynamic> json) {
    return CarsListResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CarListItem.fromJson(e as Map<String, dynamic>))
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

class CarDetailsResponse {
  final String key;
  final String msg;
  final CarDetails data;

  const CarDetailsResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory CarDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CarDetailsResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: CarDetails.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data.toJson()};
  }
}
