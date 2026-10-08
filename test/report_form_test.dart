import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/home/data/models/work_report_model.dart';
import 'package:hr_app/features/home/data/models/request/daily_report_request_model.dart';
import 'package:hr_app/features/home/presentation/widgets/report_number_field.dart';
import 'package:hr_app/features/home/presentation/widgets/work_report_dialog.dart';
import 'package:hr_app/features/salary/data/models/response/employee_salary_type.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (_) async => null,
        );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          null,
        );
  });

  test(
    'salary presentation follows authenticated role and job changes',
    () async {
      for (final entry in [
        ('manager', 'driver', EmployeeType.manager),
        ('employee', 'technician', EmployeeType.technician),
        ('employee', 'driver', EmployeeType.driver),
        ('employee', 'sales', EmployeeType.sales),
      ]) {
        SharedPreferences.setMockInitialValues({
          'user_data': jsonEncode({
            'id': 1,
            'role': entry.$1,
            'job_type': entry.$2,
            'token': '',
          }),
        });
        await UserHelper.initialize();
        expect(currentSalaryType(), entry.$3);
      }
    },
  );

  for (final job in ['driver', 'technician', 'sales', 'other']) {
    testWidgets(
      '$job submits typed counts with v2 write keys and unchanged overtime list',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'user_data': jsonEncode({
            'id': 1,
            'role': 'employee',
            'job_type': job,
            'token': '',
          }),
        });
        await UserHelper.initialize();
        WorkReportModel? submitted;
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    child: const Text('open'),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => WorkReportDialog(
                        onConfirm: (report) => submitted = report,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(390, 844),
            builder: (_, _) => MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        final expectedFields = job == 'sales'
            ? 3
            : job == 'technician'
            ? 2
            : job == 'driver'
            ? 2
            : 0;
        expect(find.byType(ReportNumberField), findsNWidgets(expectedFields));
        final overtime = find.byType(DropdownButtonFormField<String>);
        expect(
          overtime,
          job == 'driver' || job == 'other' ? findsOneWidget : findsNothing,
        );
        if (overtime.evaluate().isNotEmpty) {
          // The menu contains exactly the original whole-hour values.
          await tester.tap(overtime);
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.text('11'),
            100,
            scrollable: find.byType(Scrollable).last,
          );
          expect(find.text('11'), findsOneWidget);
          expect(find.text('12'), findsNothing);
          await tester.tap(find.text('11'));
          await tester.pumpAndSettle();
        }
        final numbers = find.byType(ReportNumberField);
        for (var index = 0; index < expectedFields; index++) {
          final field = tester.widget<ReportNumberField>(numbers.at(index));
          final input = find.descendant(
            of: numbers.at(index),
            matching: find.byType(TextFormField),
          );
          await tester.ensureVisible(input);
          await tester.enterText(input, field.decimal ? '2451.25' : '150');
        }
        final content = find.byType(TextFormField).last;
        await tester.ensureVisible(content);
        await tester.enterText(content, 'تقرير اليوم');
        await tester.ensureVisible(find.text('إرسال التقرير'));
        await tester.tap(find.text('إرسال التقرير'));
        await tester.pumpAndSettle();
        expect(submitted, isNotNull);
        final form = DailyReportRequestModel(
          workReport: submitted!,
        ).toFormMap();
        if (job == 'driver') {
          expect(form['installation_devices'], 150);
          expect(form['supply_devices'], 150);
          expect(form.containsKey('num_of_devices'), isFalse);
        }
        if (job == 'technician') expect(form['num_of_devices'], 150);
        if (job == 'technician') expect(form['num_of_meters'], 2451.25);
        if (job == 'sales') {
          for (final key in [
            'sold_devices',
            'bought_devices',
            'commercial_devices',
          ]) {
            expect(form[key], 150);
          }
        }
        if (job == 'driver' || job == 'other') {
          expect(form['overtime_hours'], 11);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
