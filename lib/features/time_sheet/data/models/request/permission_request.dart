class PermissionRequest {
  final String date; // Format: '2025-10-30'
  final String type; // 'late_clock_in' or 'early_clock_out'
  final int durationMinutes; // 15, 30, 45, etc.

  const PermissionRequest({
    required this.date,
    required this.type,
    required this.durationMinutes,
  });

  Map<String, dynamic> toFormMap() {
    return {
      'date': date,
      'type': type,
      'duration_minutes': durationMinutes.toString(),
    };
  }

  static String convertPermissionType(String uiType) {
    switch (uiType) {
      case "اذن حضور":
        return "late_clock_in";
      case "اذن انصراف":
        return "early_clock_out";
      default:
        return "late_clock_in";
    }
  }

  static int parseDuration(String durationText) {
    // "15 دقيقة" -> 15
    // "30 دقيقة" -> 30
    // "45 دقيقة" -> 45
    // "ساعة واحدة" -> 60
    // "ساعة ونصف" -> 90
    // "ساعتين" -> 120
    
    final text = durationText.trim();
    
    if (text.contains("دقيقة")) {
      final match = RegExp(r'(\d+)').firstMatch(text);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    } else if (text.contains("ساعة واحدة")) {
      return 60;
    } else if (text.contains("ساعة ونصف")) {
      return 90;
    } else if (text.contains("ساعتين")) {
      return 120;
    }
    
    return 15; // Default
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
