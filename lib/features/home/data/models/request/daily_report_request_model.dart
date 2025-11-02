import '../work_report_model.dart';

/// نموذج طلب إرسال التقرير اليومي
class DailyReportRequestModel {
  final WorkReportModel workReport;

  const DailyReportRequestModel({
    required this.workReport,
  });

  /// Convert to form data format for API
  Map<String, dynamic> toFormMap() {
    final map = <String, dynamic>{
      'content': workReport.report,
    };

    // Add optional fields based on work report
    if (workReport.devices != null && workReport.devices!.isNotEmpty) {
      map['num_of_devices'] = workReport.devices!;
    } else {
      map['num_of_devices'] = '';
    }

    if (workReport.meters != null && workReport.meters!.isNotEmpty) {
      map['num_of_meters'] = workReport.meters!;
    } else {
      map['num_of_meters'] = '';
    }

    if (workReport.overtimeHours != null && workReport.overtimeHours!.isNotEmpty) {
      map['overtime_hours'] = workReport.overtimeHours!;
    } else {
      map['overtime_hours'] = '';
    }

    if (workReport.soldDevices != null && workReport.soldDevices!.isNotEmpty) {
      map['sold_devices'] = workReport.soldDevices!;
    } else {
      map['sold_devices'] = '';
    }

    if (workReport.boughtDevices != null && workReport.boughtDevices!.isNotEmpty) {
      map['bought_devices'] = workReport.boughtDevices!;
    } else {
      map['bought_devices'] = '';
    }

    if (workReport.commercialDevices != null && workReport.commercialDevices!.isNotEmpty) {
      map['commercial_devices'] = workReport.commercialDevices!;
    } else {
      map['commercial_devices'] = '';
    }

    return map;
  }
}

