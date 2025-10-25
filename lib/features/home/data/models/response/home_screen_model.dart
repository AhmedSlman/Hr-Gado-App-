/// نموذج بيانات الشاشة الرئيسية
class HomeScreenModel {
  final String key;
  final String msg;
  final HomeScreenData data;

  const HomeScreenModel({
    required this.key,
    required this.msg,
    required this.data,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      key: json['key'] ?? '',
      msg: json['msg'] ?? '',
      data: HomeScreenData.fromJson(json['data'] ?? {}),
    );
  }

  bool get isSuccess => key == 'success';
}

/// بيانات الشاشة الرئيسية
class HomeScreenData {
  final String today;
  final ShiftData shift;
  final List<MeetingData> todayMeetings;
  final List<ArticleData> articles;
  final DailySalaryData dailySalary;

  const HomeScreenData({
    required this.today,
    required this.shift,
    required this.todayMeetings,
    required this.articles,
    required this.dailySalary,
  });

  factory HomeScreenData.fromJson(Map<String, dynamic> json) {
    return HomeScreenData(
      today: json['today'] ?? '',
      shift: ShiftData.fromJson(json['shift'] ?? {}),
      todayMeetings:
          (json['today_meetings'] as List<dynamic>?)
              ?.map((meeting) => MeetingData.fromJson(meeting))
              .toList() ??
          [],
      articles:
          (json['articles'] as List<dynamic>?)
              ?.map((article) => ArticleData.fromJson(article))
              .toList() ??
          [],
      dailySalary: DailySalaryData.fromJson(json['daily_salary'] ?? {}),
    );
  }
}

/// بيانات الوردية
class ShiftData {
  final String from;
  final String to;
  final int hours;
  final String lastTimeBeforeDeduction;
  final String? attendanceTime;
  final String? departureTime;

  const ShiftData({
    required this.from,
    required this.to,
    required this.hours,
    required this.lastTimeBeforeDeduction,
    this.attendanceTime,
    this.departureTime,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      hours: json['hours'] ?? 0,
      lastTimeBeforeDeduction: json['last_time_before_deduction'] ?? '',
      attendanceTime: json['attendance_time'],
      departureTime: json['departure_time'],
    );
  }

  bool get isCheckedIn => attendanceTime != null && attendanceTime!.isNotEmpty;
  bool get isCheckedOut => departureTime != null && departureTime!.isNotEmpty;
}

/// بيانات الاجتماعات
class MeetingData {
  final int id;
  final String title;
  final String time;
  final String link;

  const MeetingData({
    required this.id,
    required this.title,
    required this.time,
    required this.link,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

/// بيانات المقالات
class ArticleData {
  final int id;
  final String title;
  final String content;
  final int aboutEmployee;
  final EmployeeData? employee;

  const ArticleData({
    required this.id,
    required this.title,
    required this.content,
    required this.aboutEmployee,
    this.employee,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    return ArticleData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      aboutEmployee: json['about_employee'] ?? 0,
      employee: json['employee'] != null
          ? EmployeeData.fromJson(json['employee'])
          : null,
    );
  }
}

/// بيانات الموظف
class EmployeeData {
  final String name;
  final String image;
  final String jobTitle;

  const EmployeeData({
    required this.name,
    required this.image,
    required this.jobTitle,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      jobTitle: json['job_title'] ?? '',
    );
  }
}

/// بيانات الراتب اليومي
class DailySalaryData {
  final int baseDailySalary;
  final int bonus;
  final int deduction;
  final int netAmount;

  const DailySalaryData({
    required this.baseDailySalary,
    required this.bonus,
    required this.deduction,
    required this.netAmount,
  });

  factory DailySalaryData.fromJson(Map<String, dynamic> json) {
    return DailySalaryData(
      baseDailySalary: json['base_daily_salary'] ?? 0,
      bonus: json['bonus'] ?? 0,
      deduction: json['deduction'] ?? 0,
      netAmount: json['net_amount'] ?? 0,
    );
  }
}

// /// فئة الشاشة الرئيسية
// class HomeScreenCategory {
//   final int id;
//   final String name;
//   final String icon;
//   final String route;

//   const HomeScreenCategory({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.route,
//   });

//   factory HomeScreenCategory.fromJson(Map<String, dynamic> json) {
//     return HomeScreenCategory(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       icon: json['icon'] ?? '',
//       route: json['route'] ?? '',
//     );
//   }
// }
