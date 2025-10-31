class Participant {
  final int id;
  final String image;

  const Participant({required this.id, required this.image});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(id: json['id'] ?? 0, image: json['image'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image};
  }
}

class MeetingData {
  final int id;
  final String title;
  final String date;
  final String time;
  final String link;
  final List<Participant> participants;

  const MeetingData({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.link,
    required this.participants,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      link: json['link'] ?? '',
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'link': link,
      'participants': participants.map((e) => e.toJson()).toList(),
    };
  }

  // Helper method to format time for display
  String get formattedTime {
    try {
      final timeParts = time.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        final period = hour >= 12 ? 'م' : 'ص';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
      }
    } catch (e) {
      // If parsing fails, return original time
    }
    return time;
  }

  // Helper method to format date for display
  String get formattedDate {
    try {
      final dateParts = date.split('-');
      if (dateParts.length == 3) {
        final year = dateParts[0];
        final month = dateParts[1];
        final day = dateParts[2];

        // Convert month number to Arabic month name
        final monthNames = [
          '',
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ];

        final monthIndex = int.parse(month);
        if (monthIndex >= 1 && monthIndex <= 12) {
          return '$day ${monthNames[monthIndex]} $year';
        }
      }
    } catch (e) {
      // If parsing fails, return original date
    }
    return date;
  }
}

class MeetingsResponse {
  final String key;
  final String msg;
  final List<MeetingData> data;

  const MeetingsResponse({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory MeetingsResponse.fromJson(Map<String, dynamic> json) {
    return MeetingsResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => MeetingData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'msg': msg,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
