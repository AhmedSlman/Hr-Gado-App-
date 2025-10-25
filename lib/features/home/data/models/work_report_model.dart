/// نموذج تقرير العمل
class WorkReportModel {
  final String devices;
  final String meters;
  final String report;

  const WorkReportModel({
    required this.devices,
    required this.meters,
    required this.report,
  });

  @override
  String toString() {
    return 'WorkReportModel(devices: $devices, meters: $meters, report: $report)';
  }
}
