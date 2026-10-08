import 'api_values.dart';

// Employee Type Enum
enum EmployeeType {
  manager,
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
      case EmployeeType.manager:
        return const EmptyMetrics();
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
    if (json.containsKey('installation_devices') ||
        json.containsKey('supply_devices') ||
        (json.containsKey('devices') && json.containsKey('overtime_hours'))) {
      return EmployeeType.driver;
    }
    if (json.containsKey('overtime_hours') && json.keys.length == 1) {
      return EmployeeType.other;
    }
    // Default fallback
    return EmployeeType.other;
  }
}

class EmptyMetrics extends SalaryMetrics {
  const EmptyMetrics();
  @override
  Map<String, dynamic> toJson() => {};
}

class DriverMetrics extends SalaryMetrics {
  final int installationDevices;
  final int supplyDevices;
  final double overtimeHours;

  const DriverMetrics({
    required this.installationDevices,
    required this.supplyDevices,
    required this.overtimeHours,
  });

  factory DriverMetrics.fromJson(Map<String, dynamic> json) => DriverMetrics(
    installationDevices: apiCount(
      json['installation_devices'] ?? json['devices'],
    ),
    supplyDevices: apiCount(json['supply_devices']),
    overtimeHours: apiNumber(json['overtime_hours']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'installation_devices': installationDevices,
    'supply_devices': supplyDevices,
    'overtime_hours': overtimeHours,
  };
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
      soldDevices: apiCount(json['sold_devices']),
      boughtDevices: apiCount(json['bought_devices']),
      commercialDevices: apiCount(json['commercial_devices']),
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
      devices: apiCount(json['devices']),
      meters: apiNumber(json['meters']),
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
    return OtherMetrics(overtimeHours: apiNumber(json['overtime_hours']));
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
      metrics: apiMetrics(json['metrics']).isEmpty
          ? const EmptyMetrics()
          : SalaryMetrics.fromJson(apiMetrics(json['metrics']), type),
      hasReport: json['has_report'] ?? false,
      employeeType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (reportId != null) 'report_id': reportId,
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
  final double totalAllowances;
  final double insuranceDeduction;
  final List<SalaryHistoryItem> salaryHistory;
  final EmployeeType employeeType;

  const SalarySummaryData({
    required this.salaryReceiptDate,
    required this.dailySalary,
    required this.baseSalary,
    required this.netMonthlySalary,
    required this.totalDeductions,
    required this.totalBonuses,
    this.totalAllowances = 0,
    this.insuranceDeduction = 0,
    required this.salaryHistory,
    required this.employeeType,
  });

  factory SalarySummaryData.fromJson(
    Map<String, dynamic> json, {
    EmployeeType? employeeType,
  }) {
    final historyList = json['salary_history'] as List? ?? [];

    final detectedType =
        employeeType ??
        (json.containsKey('total_allowances')
            ? EmployeeType.manager
            : historyList
                      .map((item) => apiMetrics(item['metrics']))
                      .where((metrics) => metrics.isNotEmpty)
                      .map(SalaryMetrics.detectType)
                      .firstOrNull ??
                  EmployeeType.other);

    return SalarySummaryData(
      salaryReceiptDate: json['salary_receipt_date'] ?? '',
      dailySalary: apiNumber(json['daily_salary']),
      baseSalary: apiNumber(json['base_salary']),
      netMonthlySalary: apiNumber(json['net_monthly_salary']),
      totalDeductions: apiNumber(json['total_deductions']),
      totalBonuses: apiNumber(json['total_bonuses']),
      totalAllowances: apiNumber(json['total_allowances']),
      insuranceDeduction: apiNumber(json['insurance_deduction']),
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
      if (employeeType == EmployeeType.manager)
        'total_allowances': totalAllowances,
      'insurance_deduction': insuranceDeduction,
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

  factory SalarySummaryResponse.fromJson(
    Map<String, dynamic> json, {
    EmployeeType? employeeType,
  }) {
    return SalarySummaryResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: SalarySummaryData.fromJson(
        json['data'] ?? {},
        employeeType: employeeType,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'msg': msg, 'data': data.toJson()};
  }
}
