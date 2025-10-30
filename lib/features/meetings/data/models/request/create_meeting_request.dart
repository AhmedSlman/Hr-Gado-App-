class CreateMeetingRequest {
  final String title;
  final String date; // format: yyyy-MM-dd
  final String time; // format: HH:mm
  final String link;
  final List<int> participants; // employee ids

  const CreateMeetingRequest({
    required this.title,
    required this.date,
    required this.time,
    required this.link,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'date': date,
      'time': time,
      'link': link,
    };

    // API expects repeated parameters participants[]:id
    // We will build this map at request time in data source when using form encoding.
    // Here, we still keep participants for potential usage.
    json['participants'] = participants;
    return json;
  }
}
