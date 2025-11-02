/// مساعد التاريخ والوقت - Date Time Helper
/// يحتوي على جميع الدوال المتعلقة بالتاريخ والوقت
class DateTimeHelper {
  DateTimeHelper._();

  /// الحصول على التاريخ الحالي باللغة العربية
  static String getCurrentDate() {
    final now = DateTime.now();
    final weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    final months = [
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

    return '${weekdays[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';
  }

  /// الحصول على الوقت الحالي بصيغة 12 ساعة
  static String getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : hour;

    return '$displayHour:$minute $period';
  }

  /// الحصول على التاريخ والوقت معاً
  static String getCurrentDateTime() {
    return '${getCurrentDate()} - ${getCurrentTime()}';
  }

  /// تحويل الوقت من 24 ساعة إلى 12 ساعة
  static String convertTo12Hour(String time24) {
    try {
      // التحقق إذا كان الوقت بالفعل بتنسيق 12 ساعة (يحتوي على ص أو م)
      if (time24.contains('ص') || time24.contains('م')) {
        return time24; // الوقت بالفعل بتنسيق 12 ساعة
      }

      // تنظيف الوقت من أي مسافات إضافية
      final cleanedTime = time24.trim();
      final parts = cleanedTime.split(':');

      if (parts.length < 2) {
        return time24; // تنسيق غير صحيح، إرجاع الوقت الأصلي
      }

      final hour = int.parse(parts[0]);
      final minute = parts[1]
          .split(' ')
          .first; // أخذ الدقائق فقط (تجاهل أي نص إضافي)

      final period = hour >= 12 ? 'م' : 'ص';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$displayHour:$minute $period';
    } catch (e) {
      return time24; // إرجاع الوقت الأصلي في حالة الخطأ
    }
  }

  /// تحويل الوقت من 12 ساعة إلى 24 ساعة
  static String convertTo24Hour(String time12) {
    try {
      // إذا كان الوقت بالفعل بتنسيق 24 ساعة (لا يحتوي على ص أو م)
      if (!time12.contains('ص') && !time12.contains('م')) {
        // التحقق إذا كان بالفعل بتنسيق 24 ساعة
        final parts = time12.trim().split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0].trim());
          final minute = int.tryParse(parts[1].trim());
          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour < 24 &&
              minute >= 0 &&
              minute < 60) {
            return time12.trim(); // الوقت بالفعل بتنسيق 24 ساعة
          }
        }
      }

      final parts = time12.trim().split(' ');
      if (parts.length < 2) {
        return time12; // تنسيق غير صحيح
      }

      final timePart = parts[0].trim();
      final period = parts[1].trim();

      final timeParts = timePart.split(':');
      if (timeParts.length != 2) {
        return time12; // تنسيق غير صحيح
      }

      var hour = int.parse(timeParts[0].trim());
      final minute = timeParts[1].trim();

      if (period == 'م' && hour != 12) {
        hour += 12;
      } else if (period == 'ص' && hour == 12) {
        hour = 0;
      }

      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      print('🔍 Error converting time to 24h: $time12 - $e');
      return time12; // إرجاع الوقت الأصلي في حالة الخطأ
    }
  }

  /// التحقق من أن الوقت الحالي قبل وقت معين
  static bool isBeforeTime(String targetTime) {
    final currentTime = getCurrentTime();

    // مقارنة بسيطة - يمكن تحسينها لاحقاً
    return currentTime.compareTo(targetTime) < 0;
  }

  /// التحقق من أن الوقت الحالي بعد وقت معين
  static bool isAfterTime(String targetTime) {
    final currentTime = getCurrentTime();

    // مقارنة بسيطة - يمكن تحسينها لاحقاً
    return currentTime.compareTo(targetTime) > 0;
  }

  /// الحصول على اليوم من الأسبوع
  static String getWeekday() {
    final now = DateTime.now();
    final weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return weekdays[now.weekday - 1];
  }

  /// الحصول على الشهر
  static String getMonth() {
    final now = DateTime.now();
    final months = [
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
    return months[now.month - 1];
  }

  /// الحصول على السنة
  static int getYear() {
    return DateTime.now().year;
  }

  /// الحصول على اليوم من الشهر
  static int getDay() {
    return DateTime.now().day;
  }
}
