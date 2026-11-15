import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/account/data/models/response/employee_model.dart';
import 'package:hr_app/features/account/data/models/response/employees_response.dart';
import 'package:hr_app/features/account/data/repository/account_repository.dart';
import 'package:hr_app/features/account/history/history_entry_card.dart';
import 'package:hr_app/features/account/history/manager_history.dart';
import 'package:hr_app/features/account/history/manager_history_view.dart';

class UiHistoryApi implements ApiConsumer {
  Failure? failure;
  List<Map<String, dynamic>> rows = [];
  final queries = <Map<String, dynamic>>[];
  @override
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) async {
    queries.add(Map.of(queryParameters!));
    if (failure != null) return ApiResult.failure(failure!);
    return ApiResult.success(
      parser!({
        'key': 'success',
        'data': {
          'items': rows,
          'filters': {'date_from': '2026-10-17', 'date_to': '2026-11-15'},
          'pagination': {
            'current_page': 1,
            'total': rows.length,
            'has_more_pages': false,
          },
        },
      }),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class UiTeamRepository implements AccountRepository {
  @override
  Future<Result<EmployeesResponse>> fetchEmployees() async => const Right(
    EmployeesResponse(
      employees: [
        EmployeeModel(id: 42, name: 'أحمد محمود', job: 'فني', image: ''),
        EmployeeModel(id: 43, name: 'ليلى أحمد', job: 'مبيعات', image: ''),
      ],
    ),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Map<String, dynamic> uiReport() => {
  'id': 901,
  'date': '2026-11-14',
  'content':
      'تم الانتهاء من أعمال التركيب وتسليم التقرير اليومي بكامل التفاصيل.',
  'is_confirmed': false,
  'num_of_devices': 5,
  'installation_devices': 3,
  'supply_devices': 0,
  'num_of_meters': 2.5,
  'overtime_hours': 1.5,
};
Map<String, dynamic> uiDaily() => {
  'date': '2026-11-14',
  'employee': {'id': 42, 'name': 'أحمد محمود'},
  'has_attendance': true,
  'has_report': true,
  'attendance': {
    'check_in_at': '2026-11-14T21:00:00',
    'check_out_at': '2026-11-15T05:00:00',
    'status': 0,
  },
  'report': uiReport(),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late UiHistoryApi api;
  setUp(() async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({
      'user_data': jsonEncode({
        'id': 1,
        'role': 'manager',
        'job': '',
        'job_type': '',
        'image': '',
        'token': 'test',
      }),
      'is_logged_in': true,
    });
    FlutterSecureStorage.setMockInitialValues({'user_token': 'test'});
    await UserHelper.initialize();
    api = UiHistoryApi();
    sl.registerSingleton<ApiConsumer>(api);
    sl.registerSingleton<AccountRepository>(UiTeamRepository());
  });
  tearDown(() async => sl.reset());

  Future<void> pumpHistory(
    WidgetTester tester, {
    bool daily = false,
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Rubik'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        ),
        home: ManagerHistoryView(daily: daily),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'quick dates send exact Cairo day range and reset removes filters',
    (tester) async {
      await pumpHistory(tester);
      await tester.tap(find.widgetWithText(ChoiceChip, 'اليوم'));
      await tester.pumpAndSettle();
      expect(api.queries.last['date_from'], historyDate(cairoToday()));
      expect(api.queries.last['date_to'], historyDate(cairoToday()));
      await tester.tap(find.text('مسح التصفية'));
      await tester.pumpAndSettle();
      expect(api.queries.last.containsKey('date_from'), isFalse);
      expect(api.queries.last.containsKey('employee_id'), isFalse);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'searchable employee sheet applies employee ID instead of display name',
    (tester) async {
      await pumpHistory(tester);
      await tester.tap(find.byKey(const ValueKey('history-employee-filter')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('history-employee-search')),
        'ليلى',
      );
      await tester.pumpAndSettle();
      expect(find.text('أحمد محمود'), findsNothing);
      await tester.tap(find.text('ليلى أحمد'));
      await tester.pumpAndSettle();
      expect(api.queries.last['employee_id'], 43);
      expect(find.text('ليلى أحمد'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('date selection uses Arabic material localization', (
    tester,
  ) async {
    await pumpHistory(tester);
    await tester.tap(find.byKey(const ValueKey('history-date-filter')));
    await tester.pumpAndSettle();
    final dialog = find.byType(DateRangePickerDialog);
    expect(dialog, findsOneWidget);
    expect(Localizations.localeOf(tester.element(dialog)).languageCode, 'ar');

    Navigator.of(tester.element(dialog)).pop();
    await tester.pumpAndSettle();
  });
  testWidgets('Arabic calendar handles enlarged text on a narrow phone', (
    tester,
  ) async {
    await pumpHistory(tester, scale: 1.7);
    await tester.ensureVisible(
      find.byKey(const ValueKey('history-date-filter')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('history-date-filter')));
    await tester.pumpAndSettle();
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.byType(DateRangePickerDialog))).pop();
    await tester.pumpAndSettle();
  });
  test('date-window arithmetic uses calendar dates across DST boundaries', () {
    expect(historyDayOffset(DateTime(2026, 4, 25), -1), DateTime(2026, 4, 24));
    expect(
      historyDayOffset(DateTime(2026, 11, 15), -29),
      DateTime(2026, 10, 17),
    );
  });
  testWidgets('failed history can retry while keeping filters usable', (
    tester,
  ) async {
    api.failure = NetworkFailure(message: 'تعذر الاتصال بالخادم');
    await pumpHistory(tester);
    expect(find.text('تعذر تحميل السجل'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('إعادة المحاولة').last,
      150,
      scrollable: find.byType(Scrollable).first,
    );
    api.failure = null;
    await tester.pumpAndSettle();
    await tester.tap(find.text('إعادة المحاولة').last);
    await tester.pumpAndSettle();
    expect(find.text('تعذر تحميل السجل'), findsNothing);
    expect(api.queries, hasLength(2));
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'daily cards preserve overnight checkout and expand fractional report metrics',
    (tester) async {
      api.rows = [uiDaily()];
      await pumpHistory(tester, daily: true);
      await tester.scrollUntilVisible(
        find.byType(HistoryEntryCard),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('09:00 م'), findsOneWidget);
      expect(find.text('05:00 ص'), findsOneWidget);
      expect(find.text('15 نوفمبر'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('expand-42-2026-11-14')),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('expand-42-2026-11-14')));
      await tester.pumpAndSettle();
      expect(find.text('2.5'), findsOneWidget);
      expect(find.text('الأمتار'), findsOneWidget);
      expect(find.text('أجهزة التوريد'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'manager layout handles large text without overflow on narrow phone',
    (tester) async {
      api.rows = [uiDaily()];
      await pumpHistory(tester, daily: true, scale: 1.7);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.byType(HistoryEntryCard),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'missing attendance and missing checkout are distinct from absence and midnight',
    (tester) async {
      final json = uiDaily();
      json['has_attendance'] = false;
      json['attendance'] = null;
      json['has_report'] = false;
      json['report'] = null;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryEntryCard(
              row: HistoryRow.fromJson(json, daily: true),
              daily: true,
            ),
          ),
        ),
      );
      expect(find.text('لا يوجد سجل حضور'), findsOneWidget);
      expect(find.text('غائب'), findsNothing);
      expect(find.text('لم يُقدم تقرير'), findsOneWidget);
      final attended = uiDaily();
      attended['attendance'] = <String, dynamic>{
        ...(attended['attendance'] as Map<String, dynamic>),
        'check_out_at': null,
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryEntryCard(
              key: const ValueKey('other'),
              row: HistoryRow.fromJson(attended, daily: true),
              daily: true,
            ),
          ),
        ),
      );
      expect(find.text('غير مسجل'), findsOneWidget);
      expect(find.text('12:00 ص'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  test(
    'known job metrics retain relevant zero values and omit unrelated metrics',
    () {
      final values = historyMetricsForJob(
        HistoryReport.fromJson(uiReport()),
        'سائق',
      );
      expect(values, {
        'installation_devices': 3,
        'supply_devices': 0,
        'overtime_hours': 1.5,
      });
      expect(historyMetricsForJob(HistoryReport.fromJson(uiReport()), 'فني'), {
        'num_of_devices': 5,
        'num_of_meters': 2.5,
      });
    },
  );
}
