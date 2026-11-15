import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/account/data/data_source/remote/remote_data_source.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/account/data/repository/account_repository.dart';
import 'package:hr_app/features/account/history/history_entry_card.dart';
import 'package:hr_app/features/account/history/manager_history.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/presentation/views/employee_report_details_view.dart';
import 'package:hr_app/features/account/presentation/widgets/edit_report_modal.dart';
import 'package:hr_app/features/account/router/account_router.dart';
import 'package:hr_app/features/vacation/data/models/response/api_message_response.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'manager_history_widgets_test.dart' as fixture;

class ReviewRepository extends fixture.UiTeamRepository {
  final fixture.UiHistoryApi api;
  final bool daily;
  int? updatedId, approvedId;
  Map<String, dynamic>? updateBody;
  Map<String, dynamic> details = {
    ...fixture.uiReport(),
    'job_type': 'driver',
    'employee': {'id': 42, 'name': 'أحمد محمود', 'job': 'سائق', 'image': ''},
  };
  ReviewRepository(this.api, this.daily);
  @override
  Future<Result<EmployeeReportDetailsModel>> fetchEmployeeReportDetails(
    int reportId,
  ) async => Right(EmployeeReportDetailsModel.fromJson(details));
  void updateHistory(Map<String, dynamic> fields) {
    api.rows = [
      for (final row in api.rows)
        daily
            ? {
                ...row,
                'report': {
                  ...(row['report'] as Map<String, dynamic>),
                  ...fields,
                },
              }
            : {...row, ...fields},
    ];
  }

  @override
  Future<Result<ApiMessageResponse>> updateReport(
    int reportId,
    Map<String, dynamic> formData,
  ) async {
    updatedId = reportId;
    updateBody = Map.of(formData);
    details = {...details, ...formData};
    updateHistory(formData);
    return const Right(ApiMessageResponse(key: 'success', msg: 'تم الحفظ'));
  }

  @override
  Future<Result<ApiMessageResponse>> confirmReport(int reportId) async {
    approvedId = reportId;
    updateHistory({'is_confirmed': true});
    return const Right(
      ApiMessageResponse(key: 'success', msg: 'تم تأكيد التقرير'),
    );
  }
}

class WriteApi implements ApiConsumer {
  String? path, method;
  Map<String, dynamic>? body;
  @override
  Future<ApiResult<T>> post<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  }) async {
    this.path = path;
    this.body = body;
    method = 'POST';
    return ApiResult.success(
      parser!({'key': 'success', 'msg': 'تم', 'data': []}),
    );
  }

  @override
  Future<ApiResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool isFormData = false,
    bool showLoading = false,
  }) async {
    this.path = path;
    this.body = body;
    method = 'PUT';
    return ApiResult.success(
      parser!({'key': 'success', 'msg': 'تم', 'data': []}),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late fixture.UiHistoryApi api;
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
    api = fixture.UiHistoryApi();
    sl.registerSingleton<ApiConsumer>(api);
  });
  tearDown(() async => sl.reset());

  Future<(GoRouter, ReviewRepository)> openDetails(
    WidgetTester tester, {
    required bool daily,
    required bool confirmed,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final report = {...fixture.uiReport(), 'is_confirmed': confirmed};
    api.rows = [
      daily
          ? {
              ...fixture.uiDaily(),
              'attendance': <String, dynamic>{
                ...(fixture.uiDaily()['attendance'] as Map<String, dynamic>),
                'id': 710,
              },
              'report': report,
            }
          : {
              ...report,
              'employee': {'id': 42, 'name': 'أحمد محمود'},
            },
    ];
    final repository = ReviewRepository(api, daily);
    sl.registerSingleton<AccountRepository>(repository);
    sl.registerFactory<AccountCubit>(() => AccountCubit(repository));
    final router = GoRouter(
      initialLocation: daily
          ? '/account/attendance-history'
          : '/account/report-history',
      routes: AccountRouter.routes,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp.router(
          routerConfig: router,
          builder: (_, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('manage-report-901')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('manage-report-901')));
    await tester.pumpAndSettle();
    expect(find.byType(EmployeeReportDetailsView), findsOneWidget);
    expect(
      tester
          .widget<EmployeeReportDetailsView>(
            find.byType(EmployeeReportDetailsView),
          )
          .reportId,
      901,
    );
    return (router, repository);
  }

  for (final daily in [false, true]) {
    testWidgets(
      '${daily ? 'attendance' : 'report'} history edits confirmed reports and refreshes after return',
      (tester) async {
        final (router, repository) = await openDetails(
          tester,
          daily: daily,
          confirmed: true,
        );
        expect(find.text('تأكيد التقرير'), findsNothing);
        await tester.ensureVisible(find.text('تعديل التقرير'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('تعديل التقرير'));
        await tester.pumpAndSettle();
        expect(find.byType(EditReportModal), findsOneWidget);
        await tester.enterText(find.byType(TextFormField).first, '7');
        await tester.enterText(find.byType(TextFormField).last, 'تقرير معدل');
        await tester.tap(find.text('حفظ'));
        await tester.pumpAndSettle();
        expect(repository.updatedId, 901);
        expect(repository.updateBody, {
          'content': 'تقرير معدل',
          'installation_devices': 7,
        });
        router.pop();
        await tester.pumpAndSettle();
        expect(api.queries, hasLength(2));
        expect(api.queries.last['page'], 1);
        final card = tester.widget<HistoryEntryCard>(
          find.byType(HistoryEntryCard),
        );
        expect(card.row.report!.content, 'تقرير معدل');
        expect(card.row.report!.confirmed, isTrue);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      '${daily ? 'attendance' : 'report'} history approves only pending reports and refreshes after return',
      (tester) async {
        final (_, repository) = await openDetails(
          tester,
          daily: daily,
          confirmed: false,
        );
        await tester.ensureVisible(find.text('تأكيد التقرير'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('تأكيد التقرير'));
        await tester.pumpAndSettle();
        expect(repository.approvedId, isNull);
        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();
        expect(repository.approvedId, 901);
        expect(find.byType(SuccessDialogWidget), findsOneWidget);
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(api.queries, hasLength(2));
        expect(
          tester
              .widget<HistoryEntryCard>(find.byType(HistoryEntryCard))
              .row
              .report!
              .confirmed,
          isTrue,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'days without submitted reports have no report action even if callback exists',
    (tester) async {
      final row = HistoryRow.fromJson({
        ...fixture.uiDaily(),
        'has_report': false,
        'report': null,
      }, daily: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryEntryCard(row: row, daily: true, onOpenReport: () {}),
          ),
        ),
      );
      expect(find.text('تعديل التقرير'), findsNothing);
      expect(find.text('تعديل أو تأكيد التقرير'), findsNothing);
      expect(find.text('عرض التقرير والبيانات'), findsNothing);
    },
  );
  test(
    'existing write endpoints use report ID, job-specific JSON and a bodyless approval',
    () async {
      final transport = WriteApi();
      final source = AccountRemoteDataSourceImpl(transport);
      const body = {
        'content': 'تقرير',
        'installation_devices': 7,
        'supply_devices': 2,
        'overtime_hours': 1,
      };
      await source.updateReport(901, body);
      expect(transport.method, 'PUT');
      expect(transport.path, '/employee/v2/daily-reports/901');
      expect(transport.body, body);
      await source.confirmReport(901);
      expect(transport.method, 'POST');
      expect(transport.path, '/employee/confirm-report/901');
      expect(transport.body, isNull);
    },
  );
}
