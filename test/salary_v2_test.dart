import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_app/core/common/salary_updates.dart';
import 'package:hr_app/core/error/error_handler.dart';
import 'package:hr_app/core/error/failures.dart';
import 'package:hr_app/core/error/result_extensions.dart';
import 'package:hr_app/core/network/api_consumer.dart';
import 'package:hr_app/features/home/presentation/widgets/report_number_field.dart';
import 'package:hr_app/features/salary/data/data_source/remote/remote_data_source.dart';
import 'package:hr_app/features/salary/data/models/response/api_values.dart';
import 'package:hr_app/features/salary/data/models/response/personal_reports_model.dart';
import 'package:hr_app/features/salary/data/models/response/report_model.dart';
import 'package:hr_app/features/salary/data/models/response/salary_model.dart';
import 'package:hr_app/features/salary/data/repository/salary_repository.dart';
import 'package:hr_app/features/salary/logic/personal_reports_cubit.dart';
import 'package:hr_app/features/salary/logic/salary_cubit.dart';
import 'package:hr_app/features/salary/presentation/widgets/net_monthly_salary.dart';
import 'package:hr_app/features/salary/presentation/widgets/salary_transaction_card.dart';
import 'package:hr_app/features/salary/presentation/views/personal_reports_view.dart';

Map<String, dynamic> managerData() => {
  'salary_receipt_date': '25 أكتوبر',
  'daily_salary': '387.10',
  'base_salary': 12000,
  'net_monthly_salary': 11300,
  'total_deductions': 720,
  'total_bonuses': 0,
  'total_allowances': '20.00',
  'insurance_deduction': 110,
  'salary_history': List.generate(
    31,
    (index) => {
      'date': 'يوم ${index + 1}',
      'salary_text': index == 0 ? '397.1' : '387.09',
      'metrics': [],
      'has_report': false,
    },
  ),
};

class FakeApi implements ApiConsumer {
  String? path;
  Map<String, dynamic>? query;
  Map<String, dynamic> response = {'key': 'success', 'data': []};
  Failure? failure;
  @override
  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? parser,
    bool showLoading = false,
  }) async {
    this.path = path;
    query = queryParameters;
    if (failure != null) return ApiResult.failure(failure!);
    return ApiResult.success(parser!(response));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeRepository implements SalaryRepository {
  final pending = <Completer<Result<PersonalReportsResponse>>>[];
  final filters = <ReportFilters>[];
  int salaryReads = 0;
  @override
  Future<Result<PersonalReportsResponse>> getPersonalReports(
    ReportFilters filters,
  ) {
    this.filters.add(filters);
    final request = Completer<Result<PersonalReportsResponse>>();
    pending.add(request);
    return request.future;
  }

  @override
  Future<Result<SalarySummaryResponse>> getMySalarySummary() async {
    salaryReads++;
    return Right(SalarySummaryResponse.fromJson({'data': managerData()}));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'manager numeric strings and all calendar days parse without metrics',
    () {
      final summary = SalarySummaryData.fromJson(managerData());
      expect(summary.employeeType, EmployeeType.manager);
      expect(summary.dailySalary, 387.1);
      expect(summary.totalAllowances, 20);
      expect(summary.insuranceDeduction, 110);
      expect(summary.netMonthlySalary, 11300);
      expect(summary.salaryHistory, hasLength(31));
      expect(
        summary.salaryHistory.every(
          (item) => item.metrics is EmptyMetrics && item.reportId == null,
        ),
        isTrue,
      );
      expect(formatSalaryNumber(summary.dailySalary, cents: true), '387.10');
      expect(SalarySummaryData.fromJson(summary.toJson()).totalAllowances, 20);
    },
  );

  test(
    'driver split counts and legacy fallback preserve distinct supply count',
    () {
      final metrics = DriverMetrics.fromJson({
        'installation_devices': 3,
        'supply_devices': 1,
        'overtime_hours': 2,
      });
      expect(metrics.installationDevices, 3);
      expect(metrics.supplyDevices, 1);
      expect(DriverMetrics.fromJson({'devices': 8}).installationDevices, 8);
      expect(DriverMetrics.fromJson({'devices': 8}).supplyDevices, 0);
      expect(DriverMetrics.fromJson(metrics.toJson()).supplyDevices, 1);
    },
  );

  test(
    'empty first history entry does not misclassify later technician metrics',
    () {
      final summary = SalarySummaryData.fromJson({
        'daily_salary': 400,
        'net_monthly_salary': -50,
        'salary_history': [
          {'date': 'يوم 1', 'metrics': []},
          {
            'date': 'يوم 2',
            'salary_text': '575 حافز (175)',
            'metrics': {'devices': 2, 'meters': 12.5},
          },
        ],
      });
      expect(summary.employeeType, EmployeeType.technician);
      expect(summary.salaryHistory.first.metrics, isA<EmptyMetrics>());
      expect(summary.salaryHistory.last.metrics, isA<TechnicianMetrics>());
      expect(summary.salaryHistory.last.salaryText, '575 حافز (175)');
      expect(summary.netMonthlySalary, -50);
    },
  );

  test('empty history and optional report IDs are supported', () {
    expect(SalarySummaryData.fromJson({}).salaryHistory, isEmpty);
    final item = SalaryHistoryItem.fromJson({
      'metrics': {},
    }, EmployeeType.driver);
    expect(item.toJson().containsKey('report_id'), isFalse);
    expect(apiMetrics([]), isEmpty);
    expect(() => apiMetrics([1]), throwsFormatException);
  });

  test('invalid money and counts cannot silently become zero', () {
    expect(apiNumber('20.00'), 20);
    expect(apiNumber(-20), -20);
    expect(() => apiNumber('bad'), throwsFormatException);
    expect(() => apiNumber('NaN'), throwsFormatException);
    expect(() => apiCount(1.5), throwsFormatException);
  });

  test('personal report fields depend on job without employee details', () {
    for (final entry in {
      EmployeeType.driver: {
        'installation_devices': 3,
        'supply_devices': 1,
        'overtime_hours': 2,
      },
      EmployeeType.technician: {'num_of_devices': 4, 'num_of_meters': 12.5},
      EmployeeType.sales: {
        'sold_devices': 1,
        'bought_devices': 2,
        'commercial_devices': 3,
      },
      EmployeeType.other: {'overtime_hours': 1.5},
    }.entries) {
      final response = PersonalReportsResponse.fromJson({
        'data': [
          {'id': 501, 'date': 'الخميس, 1 أكتوبر', ...entry.value},
        ],
      }, entry.key);
      expect(
        response.reports.single.metrics.keys,
        unorderedEquals(entry.value.keys),
      );
      expect(response.reports.single.id, 501);
    }
    expect(
      PersonalReportsResponse.fromJson({
        'data': [],
      }, EmployeeType.driver).reports,
      isEmpty,
    );
  });

  test('filter boundaries reject invalid parameters', () {
    expect(const ReportFilters().toQuery(), isEmpty);
    expect(const ReportFilters(month: 12, year: 2030).toQuery(), {
      'month': 12,
      'year': 2030,
    });
    for (final filters in [
      const ReportFilters(month: 0),
      const ReportFilters(month: 13),
      const ReportFilters(year: 2019),
      const ReportFilters(year: 2031),
    ]) {
      expect(filters.toQuery, throwsArgumentError);
    }
  });

  test('v2 requests and legacy detail route remain separate', () async {
    final api = FakeApi();
    final remote = SalaryRemoteDataSourceImpl(api);
    api.response = {'data': managerData()};
    await remote.getMySalarySummary();
    expect(api.path, '/employee/v2/my-salary-summary');
    api.response = {'data': []};
    await remote.getPersonalReports(const ReportFilters(month: 10, year: 2026));
    expect(api.path, '/employee/v2/reports');
    expect(api.query, {'month': 10, 'year': 2026});
    api.response = {
      'data': {'id': 501, 'content': 'تقرير'},
    };
    final result = await remote.getReportDetails(501);
    expect(api.path, '/employee/v2/reports/501');
    expect(
      result.getOrElse(() => throw StateError('Unexpected error')),
      isA<ReportResponse>(),
    );
  });

  test('400 and 401 preserve backend error messages', () {
    for (final status in [400, 401]) {
      final options = RequestOptions(path: '/employee/v2/reports');
      final failure = ErrorHandler.handleDioException(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: status,
            data: {'key': 'failure', 'msg': 'خطأ التحقق', 'data': []},
          ),
        ),
      );
      expect(failure.message, 'خطأ التحقق');
      expect(
        failure,
        status == 400 ? isA<BadRequestFailure>() : isA<AuthFailure>(),
      );
    }
  });

  test('changing report filters ignores older responses', () async {
    final repository = FakeRepository();
    final cubit = PersonalReportsCubit(repository);
    final first = cubit.load(const ReportFilters(month: 1));
    final second = cubit.load(const ReportFilters(month: 2));
    repository.pending[1].complete(const Right(PersonalReportsResponse([])));
    await second;
    repository.pending[0].complete(
      Left(BadRequestFailure(message: 'old error')),
    );
    await first;
    expect(cubit.state, isA<PersonalReportsLoaded>());
    await cubit.close();
  });

  test(
    'payroll writes refresh active salary and stop after disposal',
    () async {
      final repository = FakeRepository();
      final cubit = SalaryCubit(repository);
      await cubit.getMySalarySummary();
      SalaryUpdates.notify();
      await Future<void>.delayed(Duration.zero);
      expect(repository.salaryReads, 2);
      await cubit.close();
      SalaryUpdates.notify();
      await Future<void>.delayed(Duration.zero);
      expect(repository.salaryReads, 2);
    },
  );

  test('numeric report input allows values beyond former dropdown limits', () {
    expect(validateReportNumber('150'), isNull);
    expect(validateReportNumber('2451.25', decimal: true), isNull);
    expect(validateReportNumber('0'), isNull);
    expect(validateReportNumber(''), isNotNull);
    expect(validateReportNumber('-1'), isNotNull);
    expect(validateReportNumber('1.5'), isNotNull);
    expect(validateReportNumber('1.234', decimal: true), isNotNull);
  });

  testWidgets('numeric fields accept whole device counts and decimal meters', (
    tester,
  ) async {
    String devices = '0';
    String meters = '0';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: Column(
              children: [
                ReportNumberField(
                  label: 'أجهزة',
                  initialValue: devices,
                  onChanged: (value) => devices = value,
                ),
                ReportNumberField(
                  label: 'أمتار',
                  initialValue: meters,
                  decimal: true,
                  onChanged: (value) => meters = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField).first, '150');
    await tester.enterText(find.byType(TextFormField).last, '2451.25');
    expect(devices, '150');
    expect(meters, '2451.25');
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
  });

  testWidgets(
    'manager cards show full text without metrics or report action on narrow screen',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  NetMonthlySalary(
                    salaryData: SalarySummaryData.fromJson(managerData()),
                  ),
                  const SalaryTransactionCard(
                    date: 'الخميس 1 أكتوبر',
                    metricsData: {},
                    salary: '575 حافز (175)',
                    employeeType: EmployeeType.manager,
                    hasReport: true,
                    reportId: 501,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('575 حافز (175)'), findsOneWidget);
      expect(find.text('إجمالي البدلات: 20.00'), findsOneWidget);
      expect(find.text('عرض تفاصيل التقرير'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('driver card shows both counts and overtime on narrow screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SalaryTransactionCard(
            date: 'الخميس 1 أكتوبر',
            metricsData: {
              'installation_devices': '3',
              'supply_devices': '1',
              'overtime_hours': '2',
            },
            salary: '575 حافز (175)',
            employeeType: EmployeeType.driver,
          ),
        ),
      ),
    );
    expect(find.text('أجهزة التركيب: 3'), findsOneWidget);
    expect(find.text('أجهزة التوريد: 1'), findsOneWidget);
    expect(find.text('ساعات العمل الإضافية: 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'personal report screen shows errors, retries, empty data and filter selections',
    (tester) async {
      final repository = FakeRepository();
      final cubit = PersonalReportsCubit(repository);
      addTearDown(cubit.close);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const PersonalReportsView(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(repository.filters.single.month, DateTime.now().month);
      repository.pending.last.complete(
        Left(BadRequestFailure(message: 'خطأ التحقق')),
      );
      await tester.pumpAndSettle();
      expect(find.text('خطأ التحقق'), findsOneWidget);
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pump();
      repository.pending.last.complete(
        const Right(PersonalReportsResponse([])),
      );
      await tester.pumpAndSettle();
      expect(find.text('لا توجد تقارير مؤكدة لهذا الشهر'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<int>).first);
      await tester.pumpAndSettle();
      final targetMonth = DateTime.now().month == 12
          ? 11
          : DateTime.now().month + 1;
      const monthNames = [
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
      await tester.tap(find.text(monthNames[targetMonth - 1]).last);
      await tester.pump();
      expect(repository.filters.last.month, targetMonth);
      repository.pending.last.complete(
        const Right(
          PersonalReportsResponse([
            PersonalReport(
              id: 501,
              date: 'الخميس, 1 أكتوبر',
              metrics: {
                'installation_devices': '3',
                'supply_devices': '1',
                'overtime_hours': '2',
              },
            ),
          ]),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('أجهزة التوريد: 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
