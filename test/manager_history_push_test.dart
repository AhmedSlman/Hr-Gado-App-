import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import 'package:hr_app/core/notifications/push_route.dart';
import 'package:hr_app/core/notifications/push_service.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/account/history/manager_history.dart';
import 'package:hr_app/features/notifications/data/models/response/notification_model.dart';
import 'package:hr_app/features/notifications/data/models/response/notifications_response.dart';
import 'package:hr_app/features/notifications/data/repository/notifications_repository.dart';
import 'package:hr_app/features/notifications/logic/notifications_cubit.dart';
import 'package:hr_app/features/notifications/logic/notifications_states.dart';

class HistoryApi implements ApiConsumer {
  final queries = <Map<String, dynamic>>[];
  final paths = <String>[];
  final pending = <Completer<Map<String, dynamic>>>[];
  @override
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) async {
    paths.add(path);
    queries.add(Map.of(queryParameters!));
    final completer = Completer<Map<String, dynamic>>();
    pending.add(completer);
    final response = await completer.future;
    if (response['key'] != 'success')
      return ApiResult.failure(BadRequestFailure(message: response['msg']));
    return ApiResult.success(parser!(response));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Map<String, dynamic> report(int id) => {
  'id': id,
  'date': '2026-11-14',
  'content': 'تقرير',
  'is_confirmed': false,
  'employee': {'id': 42, 'name': 'موظف'},
  'num_of_devices': 5.0,
  'installation_devices': null,
  'num_of_meters': 2.5,
  'overtime_hours': 1.5,
};
Map<String, dynamic> page(
  List<Map<String, dynamic>> rows, {
  int current = 1,
  bool more = false,
}) => {
  'key': 'success',
  'data': {
    'items': rows,
    'filters': {
      'date_from': '2026-10-17',
      'date_to': '2026-11-15',
      'timezone': 'Africa/Cairo',
    },
    'pagination': {'current_page': current, 'has_more_pages': more, 'total': 3},
  },
};

class InboxRepository implements NotificationsRepository {
  final pending = <Completer<Result<NotificationsResponse>>>[];
  @override
  Future<Result<NotificationsResponse>> getNotifications() {
    final request = Completer<Result<NotificationsResponse>>();
    pending.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> session({int id = 42, String role = 'manager'}) async {
  SharedPreferences.setMockInitialValues({
    'user_data': jsonEncode({
      'id': id,
      'role': role,
      'job': '',
      'job_type': '',
      'image': '',
      'token': 'token-$id',
    }),
    'is_logged_in': true,
  });
  FlutterSecureStorage.setMockInitialValues({'user_token': 'token-$id'});
  await UserHelper.initialize();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(session);

  test(
    'report metrics accept whole/fractional numbers and legacy installation fallback',
    () {
      final value = HistoryReport.fromJson(report(9));
      expect(value.metrics['installation_devices'], 5);
      expect(value.metrics['num_of_meters'], 2.5);
      expect(value.metrics['overtime_hours'], 1.5);
      expect(value.confirmed, isFalse);
    },
  );
  test(
    'daily rows distinguish missing attendance and submitted unconfirmed reports',
    () {
      final value = HistoryRow.fromJson({
        'date': '2026-11-14',
        'employee': {'id': 42, 'name': 'موظف'},
        'has_attendance': false,
        'has_report': true,
        'attendance': null,
        'report': report(9),
      }, daily: true);
      expect(value.hasAttendance, isFalse);
      expect(value.hasReport, isTrue);
      expect(value.report!.confirmed, isFalse);
    },
  );
  test(
    'overnight timestamps remain backend wall times without timezone conversion',
    () {
      final value = HistoryRow.fromJson({
        'date': '2026-11-14',
        'employee': {'id': 42, 'name': 'موظف'},
        'has_attendance': true,
        'has_report': false,
        'report': null,
        'attendance': {
          'check_in_at': '2026-11-14T21:00:00',
          'check_out_at': '2026-11-15T05:00:00',
          'status': 0,
        },
      }, daily: true);
      expect(value.attendance!['check_out_at'], '2026-11-15T05:00:00');
      expect(value.report, isNull);
    },
  );
  test(
    'history uses GET query, freezes resolved dates, deduplicates and obeys has_more_pages',
    () async {
      final api = HistoryApi();
      final cubit = ManagerHistoryCubit(api, daily: false);
      final first = cubit.refresh(employee: 42);
      expect(api.queries.single, {
        'employee_id': 42,
        'page': 1,
        'per_page': 20,
      });
      api.pending[0].complete(page([report(9)], more: true));
      await first;
      final second = cubit.loadMore();
      expect(api.queries[1]['date_from'], '2026-10-17');
      expect(api.queries[1]['page'], 2);
      api.pending[1].complete(page([report(9), report(8)], current: 2));
      await second;
      expect(cubit.state.rows, hasLength(2));
      expect(cubit.state.more, isFalse);
      await cubit.loadMore();
      expect(api.queries, hasLength(2));
      await cubit.close();
    },
  );
  test(
    'changing employee filters ignores stale in-flight history responses',
    () async {
      final api = HistoryApi();
      final cubit = ManagerHistoryCubit(api, daily: false);
      final stale = cubit.refresh(employee: 42);
      final latest = cubit.refresh(employee: 43);
      api.pending[1].complete(page([report(8)]));
      await latest;
      api.pending[0].complete(page([report(9)]));
      await stale;
      expect(cubit.state.rows.single.report!.id, 8);
      expect(api.queries[1]['page'], 1);
      await cubit.close();
    },
  );
  test(
    'HTTP 400 validation messages are shown and history can retry',
    () async {
      final api = HistoryApi();
      final cubit = ManagerHistoryCubit(api, daily: true);
      final first = cubit.refresh();
      api.pending[0].complete({'key': 'failure', 'msg': 'التاريخ خارج النطاق'});
      await first;
      expect(cubit.state.error, 'التاريخ خارج النطاق');
      final retry = cubit.loadMore();
      api.pending[1].complete(page([]));
      await retry;
      expect(cubit.state.error, isNull);
      expect(cubit.state.rows, isEmpty);
      await cubit.close();
    },
  );
  test('non-manager does not request team history', () async {
    await session(role: 'employee');
    final api = HistoryApi();
    final cubit = ManagerHistoryCubit(api, daily: true);
    await cubit.refresh();
    expect(api.paths, isEmpty);
    await cubit.close();
  });
  test('private pushes reject guests and another recipient', () {
    expect(
      pushDestination(
        {'type': 'deduction', 'recipient_id': '42'},
        userId: null,
        manager: false,
      ),
      isNull,
    );
    expect(
      pushDestination(
        {'type': 'deduction', 'recipient_id': '43'},
        userId: 42,
        manager: true,
      ),
      isNull,
    );
    expect(
      pushDestination({'type': 'deduction'}, userId: 42, manager: true),
      isNull,
    );
  });
  test('push families route only to existing authorized destinations', () {
    const routes = {
      'leave_approval': '/vacation/requests',
      'leave_rejected': '/vacation/requests',
      'advance_approval': '/advance/requests',
      'advance_rejected': '/advance/requests',
      'request_approval': '/time_sheet',
      'request_rejected': '/time_sheet',
      'deduction': '/salary-deductions',
      'unknown': '/notifications',
    };
    for (final entry in routes.entries) {
      expect(
        pushDestination(
          {'type': entry.key, 'recipient_id': '42'},
          userId: 42,
          manager: false,
        ),
        entry.value,
      );
    }
    expect(
      pushDestination(
        {'type': 'new_employee_request', 'recipient_id': '42'},
        userId: 42,
        manager: true,
      ),
      '/account/employee-requests',
    );
    expect(
      pushDestination(
        {'type': 'new_employee_request', 'recipient_id': '42'},
        userId: 42,
        manager: false,
      ),
      '/notifications',
    );
    expect(
      pushDestination({'type': 'announcement'}, userId: 42, manager: false),
      '/notifications',
    );
  });
  test('broadcast IDs remain separate from database notification IDs', () {
    expect(
      pushIdentity({'type': 'announcement', 'broadcast_id': 'broadcast'}),
      'broadcast',
    );
    final value = NotificationModel.fromJson({
      'id': 'db-id',
      'title': 'عنوان',
      'message': 'نص',
      'data': {'leave_id': '7'},
    });
    expect(value.copyWith(isRead: true).data['leave_id'], '7');
    expect(value.copyWith().title, 'عنوان');
  });
  test('installation UUID remains stable across account changes', () async {
    final first = await PushService.instance.installationId();
    expect(
      first,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    expect(await PushService.instance.installationId(), first);
  });
  test(
    'logout reset rejects late inbox responses from the previous session',
    () async {
      final repository = InboxRepository();
      final cubit = NotificationsCubit(repository);
      final old = cubit.getNotifications();
      cubit.resetSession();
      await session(id: 43);
      repository.pending[0].complete(
        Right(
          NotificationsResponse(
            key: 'success',
            msg: '',
            notifications: [
              NotificationModel(
                id: 'old-private',
                message: 'private',
                date: '',
                type: 'deduction',
              ),
            ],
          ),
        ),
      );
      await old;
      expect(cubit.state, isA<NotificationsInitial>());
      await cubit.close();
    },
  );
  test('concurrent inbox refreshes do not create request storms', () async {
    final repository = InboxRepository();
    final cubit = NotificationsCubit(repository);
    final first = cubit.getNotifications();
    await cubit.getNotifications();
    expect(repository.pending, hasLength(1));
    repository.pending[0].complete(
      Right(NotificationsResponse(key: 'success', msg: '', notifications: [])),
    );
    await first;
    await cubit.close();
  });
}
