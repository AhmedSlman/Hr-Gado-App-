class TimeSheetRequest {
  final int? month;
  final int? year;

  const TimeSheetRequest({this.month, this.year});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (month != null) {
      map['month'] = month;
    }
    if (year != null) {
      map['year'] = year;
    }
    return map;
  }
}


