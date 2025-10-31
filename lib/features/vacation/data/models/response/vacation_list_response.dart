class VacationStats {
  final int allowedOffDays;
  final int usedOffDays;
  final int remainingOffDays;

  const VacationStats({
    required this.allowedOffDays,
    required this.usedOffDays,
    required this.remainingOffDays,
  });

  factory VacationStats.fromJson(Map<String, dynamic> json) {
    return VacationStats(
      allowedOffDays: (json['allowed_off_days'] ?? 0) as int,
      usedOffDays: (json['used_off_days'] ?? 0) as int,
      remainingOffDays: (json['remaining_off_days'] ?? 0) as int,
    );
  }
}

class VacationLeaveItem {
  final int id;
  final String date; // e.g., "الخميس, 30 أكتوبر"
  final String numOfDays; // e.g., "33 يوم"
  final String from; // e.g., "27 ديسمبر"
  final String statusLabel;
  final String statusColor;

  const VacationLeaveItem({
    required this.id,
    required this.date,
    required this.numOfDays,
    required this.from,
    required this.statusLabel,
    required this.statusColor,
  });

  factory VacationLeaveItem.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? {}) as Map<String, dynamic>;
    return VacationLeaveItem(
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '').toString(),
      numOfDays: (json['num_of_days'] ?? '').toString(),
      from: (json['from'] ?? '').toString(),
      statusLabel: (status['label'] ?? '').toString(),
      statusColor: (status['color'] ?? '').toString(),
    );
  }
}

class VacationListResponse {
  final VacationStats stats;
  final List<VacationLeaveItem> leaves;

  const VacationListResponse({required this.stats, required this.leaves});

  factory VacationListResponse.fromRoot(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final stats = VacationStats.fromJson(
      (data['stats'] ?? {}) as Map<String, dynamic>,
    );
    final leavesJson = (data['leaves'] ?? []) as List;
    final leaves = leavesJson
        .map((e) => VacationLeaveItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return VacationListResponse(stats: stats, leaves: leaves);
  }
}
