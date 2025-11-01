import 'notification_model.dart';

class NotificationsResponse {
  final String key;
  final String msg;
  final List<NotificationModel> notifications;

  const NotificationsResponse({
    required this.key,
    required this.msg,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      notifications:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    NotificationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'msg': msg,
      'data': notifications.map((n) => n.toJson()).toList(),
    };
  }
}
