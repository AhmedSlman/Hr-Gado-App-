class UpdateReportRequest {
  final String? installationDevices;
  final String? supplyDevices;
  final String? content;
  final String? numOfDevices;
  final String? numOfMeters;
  final String? overtimeHours;
  final String? soldDevices;
  final String? boughtDevices;
  final String? commercialDevices;

  const UpdateReportRequest({
    this.content,
    this.installationDevices,
    this.supplyDevices,
    this.numOfDevices,
    this.numOfMeters,
    this.overtimeHours,
    this.soldDevices,
    this.boughtDevices,
    this.commercialDevices,
  });

  Map<String, dynamic> toFormMap() {
    final map = <String, dynamic>{};
    if (installationDevices != null)
      map['installation_devices'] = int.parse(installationDevices!);
    if (supplyDevices != null)
      map['supply_devices'] = int.parse(supplyDevices!);

    if (content != null && content!.isNotEmpty) {
      map['content'] = content!;
    }
    if (numOfDevices != null && numOfDevices!.isNotEmpty) {
      map['num_of_devices'] = numOfDevices!;
    }
    if (numOfMeters != null && numOfMeters!.isNotEmpty) {
      map['num_of_meters'] = numOfMeters!;
    }
    if (overtimeHours != null && overtimeHours!.isNotEmpty) {
      map['overtime_hours'] = overtimeHours!;
    }
    if (soldDevices != null && soldDevices!.isNotEmpty) {
      map['sold_devices'] = soldDevices!;
    }
    if (boughtDevices != null && boughtDevices!.isNotEmpty) {
      map['bought_devices'] = boughtDevices!;
    }
    if (commercialDevices != null && commercialDevices!.isNotEmpty) {
      map['commercial_devices'] = commercialDevices!;
    }

    return map;
  }
}
