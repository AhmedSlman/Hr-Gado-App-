import 'package:go_router/go_router.dart';
import '../../router/salary_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/response/personal_reports_model.dart';
import '../../logic/personal_reports_cubit.dart';
import '../widgets/report_metric_labels.dart';

class PersonalReportsView extends StatefulWidget {
  const PersonalReportsView({super.key});
  @override
  State<PersonalReportsView> createState() => _PersonalReportsViewState();
}

class _PersonalReportsViewState extends State<PersonalReportsView> {
  late int _month;
  late int _year;
  static const _months = [
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

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year.clamp(2020, 2030);
    _load();
  }

  Future<void> _load() => context.read<PersonalReportsCubit>().load(
    ReportFilters(month: _month, year: _year),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تقاريري المؤكدة')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _month,
                  decoration: const InputDecoration(labelText: 'الشهر'),
                  items: [
                    for (var month = 1; month <= 12; month++)
                      DropdownMenuItem(
                        value: month,
                        child: Text(_months[month - 1]),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _month = value);
                      _load();
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _year,
                  decoration: const InputDecoration(labelText: 'السنة'),
                  items: [
                    for (var year = 2020; year <= 2030; year++)
                      DropdownMenuItem(value: year, child: Text('$year')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _year = value);
                      _load();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<PersonalReportsCubit, PersonalReportsState>(
            builder: (context, state) {
              if (state is PersonalReportsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PersonalReportsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        TextButton(
                          onPressed: _load,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final reports = (state as PersonalReportsLoaded).reports;
              return RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (reports.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'لا توجد تقارير مؤكدة لهذا الشهر',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    for (final report in reports)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                report.date,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () async {
                                  await context.push(
                                    SalaryRoutes.reportDetails,
                                    extra: {
                                      'reportId': report.id,
                                      'date': report.date,
                                      'metricsData': report.metrics,
                                    },
                                  );
                                  if (context.mounted) await _load();
                                },
                                child: const Text('عرض تفاصيل التقرير'),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 20,
                                runSpacing: 12,
                                children: [
                                  for (final metric in report.metrics.entries)
                                    Text(
                                      '${reportMetricLabels[metric.key] ?? metric.key}: ${metric.value}',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
