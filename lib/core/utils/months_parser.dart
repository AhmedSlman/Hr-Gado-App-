String? extractMonthsNumber(String label) {
  // Normalize label
  final normalized = label.trim();

  // 1) Try to extract western or Arabic-Indic digits
  final digitMatch = RegExp(r'[\u0660-\u0669\d]+').firstMatch(normalized);
  if (digitMatch != null) {
    final raw = digitMatch.group(0)!;
    final asWestern = _arabicIndicToWestern(raw);
    return asWestern;
  }

  // 2) Map common Arabic phrases to numbers as strings
  final map = <String, String>{
    'شهر واحد': '1',
    'شهر': '1',
    'شهرين': '2',
    'شهران': '2',
    'ثلاثة أشهر': '3',
    'ثلاث شهور': '3',
    'أربعة أشهر': '4',
    'اربعة أشهر': '4',
    'خمسة أشهر': '5',
    'ستة أشهر': '6',
    'سبعة أشهر': '7',
    'ثمانية أشهر': '8',
    'تسعة أشهر': '9',
    'عشرة أشهر': '10',
    'إحدى عشر شهراً': '11',
    'إحدي عشر شهراً': '11',
    'احدى عشر شهراً': '11',
    'اثنا عشر شهراً': '12',
    'إثنا عشر شهراً': '12',
  };
  return map[normalized];
}

String _arabicIndicToWestern(String input) {
  const arabicIndic = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };
  final buffer = StringBuffer();
  for (final ch in input.split('')) {
    buffer.write(arabicIndic[ch] ?? ch);
  }
  return buffer.toString();
}
