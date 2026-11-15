/// Routing is deliberately limited to existing app capabilities.
String? pushDestination(
  Map<String, dynamic> data, {
  required int? userId,
  required bool manager,
}) {
  if (userId == null) return null;
  final type = data['type']?.toString();
  if (type != 'announcement' &&
      data['recipient_id']?.toString() != userId.toString()) {
    return null;
  }
  return switch (type) {
    'leave_approval' || 'leave_rejected' => '/vacation/requests',
    'advance_approval' || 'advance_rejected' => '/advance/requests',
    'request_approval' || 'request_rejected' => '/time_sheet',
    'deduction' => '/salary-deductions',
    'new_employee_request' =>
      manager ? '/account/employee-requests' : '/notifications',
    _ => '/notifications',
  };
}

String? pushIdentity(Map<String, dynamic> data) =>
    (data['notification_id'] ?? data['broadcast_id'])?.toString();
