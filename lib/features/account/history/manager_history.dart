import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../../../core/network/api_consumer.dart';
import '../../../core/utils/user_helper.dart';

DateTime cairoToday() {
  tzdata.initializeTimeZones();
  final now = tz.TZDateTime.now(tz.getLocation('Africa/Cairo'));
  return DateTime(now.year, now.month, now.day);
}

String historyDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// Calendar arithmetic avoids daylight-saving shifts from 24-hour subtraction.
DateTime historyDayOffset(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

class HistoryReport {
  final int id;
  final String date, content;
  final bool confirmed;
  final Map<String, num> metrics;
  HistoryReport.fromJson(Map<String, dynamic> json)
    : id = (json['id'] as num).toInt(),
      date = json['date'] as String,
      content = json['content'] as String? ?? '',
      confirmed = json['is_confirmed'] == true,
      metrics = {
        for (final key in metricLabels.keys)
          key:
              (json[key] as num?) ??
              (key == 'installation_devices'
                  ? (json['num_of_devices'] as num? ?? 0)
                  : 0),
      };
}

const metricLabels = {
  'num_of_devices': 'عدد الأجهزة',
  'installation_devices': 'أجهزة التركيب',
  'supply_devices': 'أجهزة التوريد',
  'num_of_meters': 'الأمتار',
  'overtime_hours': 'ساعات إضافية',
  'sold_devices': 'أجهزة مباعة',
  'bought_devices': 'أجهزة مشتراة',
  'commercial_devices': 'أجهزة تجارية',
};

class HistoryRow {
  final int employeeId;
  final String name, date;
  final HistoryReport? report;
  final Map<String, dynamic>? attendance;
  final bool hasAttendance, hasReport;
  HistoryRow.fromJson(Map<String, dynamic> json, {required bool daily})
    : employeeId = (json['employee']['id'] as num).toInt(),
      name = json['employee']['name'] as String,
      date = json['date'] as String,
      report = daily
          ? (json['report'] == null
                ? null
                : HistoryReport.fromJson(json['report']))
          : HistoryReport.fromJson(json),
      attendance = daily ? json['attendance'] as Map<String, dynamic>? : null,
      hasAttendance = json['has_attendance'] == true,
      hasReport = !daily || json['has_report'] == true;
  String get key => report != null && attendance == null
      ? 'report:${report!.id}:$employeeId:$date'
      : '$employeeId:$date';
}

class HistoryState {
  final List<HistoryRow> rows;
  final bool loading, more;
  final String? error;
  final int total;
  const HistoryState({
    this.rows = const [],
    this.loading = false,
    this.more = false,
    this.error,
    this.total = 0,
  });
}

class ManagerHistoryCubit extends Cubit<HistoryState> {
  final ApiConsumer api;
  final bool daily;
  int? employeeId;
  String? from, to;
  int _page = 0, _generation = 0;
  ManagerHistoryCubit(this.api, {required this.daily})
    : super(const HistoryState());

  Future<void> refresh({
    int? employee,
    String? dateFrom,
    String? dateTo,
  }) async {
    employeeId = employee;
    from = dateFrom;
    to = dateTo;
    _page = 0;
    _generation++;
    emit(const HistoryState());
    await loadMore();
  }

  Future<void> loadMore() async {
    if (state.loading || (_page > 0 && !state.more)) return;
    if (!UserHelper.isManager || !UserHelper.isLoggedIn) return;
    final generation = _generation;
    final previous = state;
    emit(
      HistoryState(
        rows: previous.rows,
        loading: true,
        more: previous.more,
        total: previous.total,
      ),
    );
    final result = await api.get<Map<String, dynamic>>(
      path: '/employee/v2/manager/${daily ? 'attendance' : 'reports'}/history',
      queryParameters: {
        if (employeeId != null) 'employee_id': employeeId,
        if (from != null) 'date_from': from,
        if (to != null) 'date_to': to,
        'page': _page + 1,
        'per_page': 20,
      },
      parser: (json) {
        if (json['key'] != 'success') {
          throw FormatException(json['msg']?.toString() ?? 'تعذر تحميل السجل');
        }
        return json['data'] as Map<String, dynamic>;
      },
    );
    if (isClosed || generation != _generation) return;
    if (result.isFailure) {
      emit(
        HistoryState(
          rows: previous.rows,
          more: previous.more,
          total: previous.total,
          error: result.failure!.message,
        ),
      );
      return;
    }
    try {
      final data = result.data!;
      final filters = data['filters'] as Map<String, dynamic>;
      from = filters['date_from'] as String;
      to = filters['date_to'] as String;
      final pagination = data['pagination'] as Map<String, dynamic>;
      final rows = <String, HistoryRow>{
        for (final row in previous.rows)
          (daily ? '${row.employeeId}:${row.date}' : '${row.report!.id}'): row,
        for (final json in data['items'] as List)
          (daily
              ? '${json['employee']['id']}:${json['date']}'
              : '${json['id']}'): HistoryRow.fromJson(
            json,
            daily: daily,
          ),
      };
      _page = (pagination['current_page'] as num).toInt();
      emit(
        HistoryState(
          rows: rows.values.toList(),
          more: pagination['has_more_pages'] == true,
          total: (pagination['total'] as num).toInt(),
        ),
      );
    } catch (_) {
      emit(
        HistoryState(
          rows: previous.rows,
          more: previous.more,
          error: 'تعذر قراءة بيانات السجل. أعد المحاولة.',
        ),
      );
    }
  }
}
