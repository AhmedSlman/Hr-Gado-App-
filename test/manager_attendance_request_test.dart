import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/account/di/account_di.dart';
import 'package:hr_app/features/account/router/account_names.dart';
import 'package:hr_app/features/account/router/account_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _AttendanceApi implements ApiConsumer {
  final paths = <String>[];

  @override
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) async {
    paths.add(path);
    final data = switch (path) {
      '/employee/employee-requests' => [
        {
          'id': 156,
          'date': '2026-11-23',
          'employee_name': 'Test employee',
          'type': 'attendance',
          'type_name': 'طلب حضور',
          'duration_minutes': 30,
          'request_type': 'early_clock_out',
          'request_type_name': 'طلب انصراف مبكر',
        },
      ],
      '/employee/attendance-request-details/156' => {
        'id': 156,
        'employee_name': 'Test employee',
        'date': '2026-11-23',
        'type': 'early_clock_out',
        'type_name': 'طلب انصراف مبكر',
        'duration_minutes': 30,
        'status': 0,
        'status_name': 'في الانتظار',
      },
      _ => throw StateError('Unexpected request $path'),
    };
    return ApiResult.success(parser!({'key': 'success', 'data': data}));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('manager opens early clock-out from the employee request list', (
    tester,
  ) async {
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
    final api = _AttendanceApi();
    sl.registerSingleton<ApiConsumer>(api);
    AccountDI.setup();
    addTearDown(sl.reset);

    final router = GoRouter(
      initialLocation: AccountRoutes.employeeRequests,
      routes: AccountRouter.routes,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        builder: (_, _) => MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('طلب انصراف مبكر'));
    await tester.pumpAndSettle();

    expect(api.paths, [
      '/employee/employee-requests',
      '/employee/attendance-request-details/156',
    ]);
    expect(find.text('تفاصيل طلب الحضور'), findsOneWidget);
    expect(find.text('30 دقيقة'), findsOneWidget);
    expect(find.text('في الانتظار'), findsOneWidget);
  });
}
