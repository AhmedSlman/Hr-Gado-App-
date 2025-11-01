/// نموذج تقرير العمل
/// يدعم جميع أنواع المستخدمين: driver, sales, technician, other
class WorkReportModel {
  // Common fields
  final String report; // تقرير عمل اليوم - موجود في جميع الأنواع

  // Driver & Technician fields
  final String? devices; // عدد الأجهزة - driver, technician

  // Driver & Other fields
  final String? overtimeHours; // ساعات عمل إضافية - driver, other

  // Technician field
  final String? meters; // عدد الأمتار - technician only

  // Sales fields
  final String? soldDevices; // عدد الأجهزة المباعة - sales only
  final String? boughtDevices; // عدد الأجهزة المشتراة - sales only
  final String? commercialDevices; // عدد الأجهزة التجارية - sales only

  const WorkReportModel({
    required this.report,
    this.devices,
    this.meters,
    this.overtimeHours,
    this.soldDevices,
    this.boughtDevices,
    this.commercialDevices,
  });

  @override
  String toString() {
    return 'WorkReportModel(devices: $devices, meters: $meters, overtimeHours: $overtimeHours, soldDevices: $soldDevices, boughtDevices: $boughtDevices, commercialDevices: $commercialDevices, report: $report)';
  }
}
