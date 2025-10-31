class CreateCarRequest {
  final String model;
  final String licensePlate;
  final String licenseIssue; // format: yyyy-MM-dd
  final String licenseRenewal; // format: yyyy-MM-dd
  final String lastOilChange; // format: yyyy-MM-dd
  final String nextOilChange; // format: yyyy-MM-dd
  final int employeeId;

  const CreateCarRequest({
    required this.model,
    required this.licensePlate,
    required this.licenseIssue,
    required this.licenseRenewal,
    required this.lastOilChange,
    required this.nextOilChange,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'license_plate': licensePlate,
      'license_issue': licenseIssue,
      'license_renewal': licenseRenewal,
      'last_oil_change': lastOilChange,
      'next_oil_change': nextOilChange,
      'employee_id': employeeId,
    };
  }
}
