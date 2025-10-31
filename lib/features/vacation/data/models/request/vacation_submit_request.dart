class VacationSubmitRequest {
  final String type; // 'normal' | 'long_term'
  final String fromDate; // YYYY-MM-DD
  final String toDate; // YYYY-MM-DD
  final String? reason;

  const VacationSubmitRequest({
    required this.type,
    required this.fromDate,
    required this.toDate,
    this.reason,
  });

  Map<String, dynamic> toFormMap() {
    return {
      'type': type,
      'from': fromDate,
      'to': toDate,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }
}

class AdvanceSubmitRequest {
  final String type; // 'normal' | 'long_term'
  final String amount; // as string per backend example
  final String? numberOfMonths; // required for long_term

  const AdvanceSubmitRequest({
    required this.type,
    required this.amount,
    this.numberOfMonths,
  });

  Map<String, dynamic> toFormMap() {
    return {
      'type': type,
      'amount': amount,
      if (numberOfMonths != null && numberOfMonths!.isNotEmpty)
        'number_of_months': int.tryParse(numberOfMonths!) ?? numberOfMonths,
    };
  }
}
