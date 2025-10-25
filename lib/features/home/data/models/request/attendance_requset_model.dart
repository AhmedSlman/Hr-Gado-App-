class AttendanceRequestModel {
  final double latitude;
  final double longitude;

  const AttendanceRequestModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
