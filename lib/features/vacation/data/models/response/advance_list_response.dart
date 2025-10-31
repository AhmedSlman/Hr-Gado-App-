class AdvanceStats {
  final String latestAdvanceDate;
  const AdvanceStats({required this.latestAdvanceDate});

  factory AdvanceStats.fromJson(Map<String, dynamic> json) {
    return AdvanceStats(
      latestAdvanceDate: (json['latest_advance_date'] ?? '').toString(),
    );
  }
}

class AdvanceItem {
  final int id;
  final String date;
  final num amount;
  final String statusLabel;
  final String statusColor;

  const AdvanceItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.statusLabel,
    required this.statusColor,
  });

  factory AdvanceItem.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? {}) as Map<String, dynamic>;
    return AdvanceItem(
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '').toString(),
      amount: (json['amount'] ?? 0),
      statusLabel: (status['label'] ?? '').toString(),
      statusColor: (status['color'] ?? '').toString(),
    );
  }
}

class AdvanceListResponse {
  final AdvanceStats stats;
  final List<AdvanceItem> advances;

  const AdvanceListResponse({required this.stats, required this.advances});

  factory AdvanceListResponse.fromRoot(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final stats = AdvanceStats.fromJson(
      (data['stats'] ?? {}) as Map<String, dynamic>,
    );
    final list = (data['advances'] ?? []) as List;
    final advances = list
        .map((e) => AdvanceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return AdvanceListResponse(stats: stats, advances: advances);
  }
}
