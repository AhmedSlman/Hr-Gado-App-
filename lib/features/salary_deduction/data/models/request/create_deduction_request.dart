class CreateDeductionRequest {
  final int amount;
  final String type;
  final int employeeId;

  const CreateDeductionRequest({
    required this.amount,
    required this.type,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'type': type, 'employee_id': employeeId};
  }
}
