class NotificationsEndpoints {
  static const String notifications = '/employee/notifications';
  static String markAsRead(String notificationId) =>
      '/employee/notifications/$notificationId/mark-read';
  static const String markAllAsRead = '/employee/notifications/mark-all-read';
}

