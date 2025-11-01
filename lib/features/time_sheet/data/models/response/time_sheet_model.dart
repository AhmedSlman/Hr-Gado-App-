class TimeSheetModel {
  final int id;
  final String date;
  final String attendance;
  final String departure;

  const TimeSheetModel({
    required this.id,
    required this.date,
    required this.attendance,
    required this.departure,
  });

  factory TimeSheetModel.fromJson(Map<String, dynamic> json) {
    return TimeSheetModel(
      id: (json['id'] ?? 0) as int,
      date: (json['date'] ?? '') as String,
      attendance: (json['attendance'] ?? '') as String,
      departure: (json['departure'] ?? '') as String,
    );
  }
}


