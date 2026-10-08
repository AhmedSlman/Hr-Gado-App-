import '../work_report_model.dart';

class DailyReportRequestModel {
  final WorkReportModel workReport;
  const DailyReportRequestModel({required this.workReport});
  Map<String, dynamic> toFormMap() => {
    'content': workReport.report,
    if (workReport.installationDevices != null)
      'installation_devices': int.parse(workReport.installationDevices!),
    if (workReport.supplyDevices != null)
      'supply_devices': int.parse(workReport.supplyDevices!),
    if (workReport.devices != null)
      'num_of_devices': int.parse(workReport.devices!),
    if (workReport.meters != null)
      'num_of_meters': double.parse(workReport.meters!),
    if (workReport.overtimeHours != null)
      'overtime_hours': double.parse(workReport.overtimeHours!),
    if (workReport.soldDevices != null)
      'sold_devices': int.parse(workReport.soldDevices!),
    if (workReport.boughtDevices != null)
      'bought_devices': int.parse(workReport.boughtDevices!),
    if (workReport.commercialDevices != null)
      'commercial_devices': int.parse(workReport.commercialDevices!),
  };
}
