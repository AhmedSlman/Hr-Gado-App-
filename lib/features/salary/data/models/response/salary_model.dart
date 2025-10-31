// Employee Type Enum
enum EmployeeType {
  driver, // السواق
  sales, // المبيعات
  technician, // الفني
  other, // آخرون
}

// Sealed class for different metrics types
sealed class SalaryMetrics {
  const SalaryMetrics();

  factory SalaryMetrics.fromJson(Map<String, dynamic> json, EmployeeType type) {
    switch (type) {
      case EmployeeType.driver:
        return DriverMetrics.fromJson(json);
      case EmployeeType.sales:
        return SalesMetrics.fromJson(json);
      case EmployeeType.technician:
        return TechnicianMetrics.fromJson(json);
      case EmployeeType.other:
        return OtherMetrics.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();

  // Helper method to detect employee type from metrics keys
  static EmployeeType detectType(Map<String, dynamic> json) {
    if (json.containsKey('sold_devices') ||
        json.containsKey('bought_devices') ||
        json.containsKey('commercial_devices')) {
      return EmployeeType.sales;
    }
    if (json.containsKey('meters') && json.containsKey('devices')) {
      return EmployeeType.technician;
    }
    if (json.containsKey('devices') && json.containsKey('overtime_hours')) {
      return EmployeeType.driver;
    }
    if (json.containsKey('overtime_hours') && json.keys.length == 1) {
      return EmployeeType.other;
    }
    // Default fallback
    return EmployeeType.driver;
  }
}

// Driver Metrics (السواق)
class DriverMetrics extends SalaryMetrics {
  final int devices;
  final double overtimeHours;

  const DriverMetrics({required this.devices, required this.overtimeHours});

  factory DriverMetrics.fromJson(Map<String, dynamic> json) {
    return DriverMetrics(
      devices: json['devices'] ?? 0,
      overtimeHours: (json['overtime_hours'] ?? 0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'devices': devices, 'overtime_hours': overtimeHours};
  }
}

// Sales Metrics (المبيعات)
class SalesMetrics extends SalaryMetrics {
  final int soldDevices;
  final int boughtDevices;
  final int commercialDevices;

  const SalesMetrics({
    required this.soldDevices,
    required this.boughtDevices,
    required this.commercialDevices,
  });

  factory SalesMetrics.fromJson(Map<String, dynamic> json) {
    return SalesMetrics(
      soldDevices: json['sold_devices'] ?? 0,
      boughtDevices: json['bought_devices'] ?? 0,
      commercialDevices: json['commercial_devices'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sold_devices': soldDevices,
      'bought_devices': boughtDevices,
      'commercial_devices': commercialDevices,
    };
  }
}

// Technician Metrics (الفني)
class TechnicianMetrics extends SalaryMetrics {
  final int devices;
  final double meters;

  const TechnicianMetrics({required this.devices, required this.meters});

  factory TechnicianMetrics.fromJson(Map<String, dynamic> json) {
    return TechnicianMetrics(
      devices: json['devices'] ?? 0,
      meters: (json['meters'] ?? 0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'devices': devices, 'meters': meters};
  }
}

// Other Metrics (آخرون)
class OtherMetrics extends SalaryMetrics {
  final double overtimeHours;

  const OtherMetrics({required this.overtimeHours});

  factory OtherMetrics.fromJson(Map<String, dynamic> json) {
    return OtherMetrics(
      overtimeHours: (json['overtime_hours'] ?? 0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'overtime_hours': overtimeHours};
  }
}

class SalaryHistoryItem {
  final int? reportId;
  final String date;
  final String salaryText;
  final SalaryMetrics metrics;
  final bool hasReport;
  final EmployeeType employeeType;

  const SalaryHistoryItem({
    this.reportId,
    required this.date,
    required this.salaryText,
    required this.metrics,
    required this.hasReport,
    required this.employeeType,
  });

  factory SalaryHistoryItem.fromJson(
    Map<String, dynamic> json,
    EmployeeType type,
  ) {
    return SalaryHistoryItem(
      reportId: json['report_id'],
      date: json['date'] ?? '',
      salaryText: json['salary_text'] ?? '',
      metrics: SalaryMetrics.fromJson(json['metrics'] ?? {}, type),
      hasReport: json['has_report'] ?? false,
      employeeType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_id': reportId,
      'date': date,
      'salary_text': salaryText,
      'metrics': metrics.toJson(),
      'has_report': hasReport,
    };
  }
}

class SalarySummaryData {
  final String salaryReceiptDate;
  final double dailySalary;
  final double baseSalary;
  final double netMonthlySalary;
  final double totalDeductions;
  final double totalBonuses;
  final List<SalaryHistoryItem> salaryHistory;
  final EmployeeType employeeType;

  const SalarySummaryData({
    required this.salaryReceiptDate,
    required this.dailySalary,
    required this.baseSalary,
    required this.netMonthlySalary,
    required this.totalDeductions,
    required this.totalBonuses,
    required this.salaryHistory,
    required this.employeeType,
  });

  factory SalarySummaryData.fromJson(Map<String, dynamic> json) {
    final historyList = json['salary_history'] as List? ?? [];

    // Detect employee type from first history item metrics
    EmployeeType detectedType = EmployeeType.driver;
    if (historyList.isNotEmpty) {
      final firstMetrics =
          historyList.first['metrics'] as Map<String, dynamic>? ?? {};
      detectedType = SalaryMetrics.detectType(firstMetrics);
    }

    return SalarySummaryData(
      salaryReceiptDate: json['salary_receipt_date'] ?? '',
      dailySalary: (json['daily_salary'] ?? 0).toDouble(),
      baseSalary: (json['base_salary'] ?? 0).toDouble(),
      netMonthlySalary: (json['net_monthly_salary'] ?? 0).toDouble(),
      totalDeductions: (json['total_deductions'] ?? 0).toDouble(),
      totalBonuses: (json['total_bonuses'] ?? 0).toDouble(),
      salaryHistory: historyList
          .map((item) => SalaryHistoryItem.fromJson(item, detectedType))
          .toList(),
      employeeType: detectedType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salary_receipt_date': salaryReceiptDate,
      'daily_salary': dailySalary,
      'base_salary': baseSalary,
      'net_monthly_salary': netMonthlySalary,
      'total_deductions': totalDeductions,
      'total_bonuses': totalBonuses,
      'salary_history': salaryHistory.map((item) => item.toJson()).toList(),
    };
  }
}

class SalarySummaryResponse {
  final String key;
  final String msg;
  final SalarySummaryData data;

  const SalarySummaryResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory SalarySummaryResponse.fromJson(Map<String, dynamic> json) {
    return SalarySummaryResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: SalarySummaryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data.toJson()};
  }
}
