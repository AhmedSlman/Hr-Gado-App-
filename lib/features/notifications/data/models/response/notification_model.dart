class NotificationModel {
  final String id;
  final String message;
  final String date;
  final bool isRead;
  final String type;
  final String title;
  final Map<String, dynamic> data;

  const NotificationModel({
    required this.id,
    required this.message,
    required this.date,
    this.isRead = false,
    required this.type,
    this.title = '',
    this.data = const {},
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      date: json['created_at'] ?? '',
      isRead: false, // Backend doesn't return is_read status
      type: json['type'] ?? '',
      title: json['title']?.toString() ?? '',
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? message,
    String? date,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      title: title,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'created_at': date,
      'is_read': isRead,
      'type': type,
      'title': title,
      'data': data,
    };
  }
}
