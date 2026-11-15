import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../core/locator/service_locator.dart';
import '../../../core/network/api_consumer.dart';
import '../../../core/utils/user_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../data/repository/account_repository.dart';
import '../data/models/response/employee_model.dart';
import '../router/account_names.dart';
import '../router/account_route_extra.dart';
import 'manager_history.dart';
import 'history_entry_card.dart';
import 'history_employee_picker.dart';

class ManagerHistoryView extends StatefulWidget {
  final bool daily;
  const ManagerHistoryView({super.key, required this.daily});
  @override
  State<ManagerHistoryView> createState() => _ManagerHistoryViewState();
}

class _ManagerHistoryViewState extends State<ManagerHistoryView> {
  late final ManagerHistoryCubit cubit;
  final scroll = ScrollController();
  List<EmployeeModel> employees = [];
  int? employee;
  DateTimeRange? dates;
  String? employeeError;
  bool employeesLoading = false, employeesLoaded = false;
  bool openingReport = false;

  @override
  void initState() {
    super.initState();
    cubit = ManagerHistoryCubit(sl<ApiConsumer>(), daily: widget.daily);
    if (UserHelper.isManager) {
      cubit.refresh();
      _loadEmployees();
    }
  }

  @override
  void dispose() {
    cubit.close();
    scroll.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    if (employeesLoading) return;
    setState(() => employeesLoading = true);
    try {
      final result = await sl<AccountRepository>().fetchEmployees();
      if (!mounted) return;
      result.fold(
        (failure) => setState(() => employeeError = failure.message),
        (data) => setState(() {
          employees = data.employees;
          employeesLoaded = true;
          employeeError = null;
        }),
      );
    } catch (_) {
      if (mounted) setState(() => employeeError = 'تعذر تحميل قائمة الموظفين');
    } finally {
      if (mounted) setState(() => employeesLoading = false);
    }
  }

  Future<void> _refresh() => cubit.refresh(
    employee: employee,
    dateFrom: dates == null ? null : historyDate(dates!.start),
    dateTo: dates == null ? null : historyDate(dates!.end),
  );

  Future<void> _openReport(HistoryRow row) async {
    final report = row.report;
    if (!row.hasReport || report == null || openingReport) return;
    openingReport = true;
    try {
      await context.push(
        AccountRoutes.employeeReportDetails,
        extra: EmployeeReportDetailsExtra(
          reportId: report.id,
          isConfirmed: report.confirmed,
        ),
      );
    } finally {
      openingReport = false;
    }
    if (!mounted) return;
    if (scroll.hasClients) scroll.jumpTo(0);
    await _refresh();
  }

  void _reset() {
    setState(() {
      employee = null;
      dates = null;
    });
    _refresh();
  }

  void _selectPeriod(int days) {
    final today = cairoToday();
    setState(
      () => dates = days == 30
          ? null
          : DateTimeRange(
              start: historyDayOffset(today, days == -1 ? -1 : 1 - days),
              end: days == -1 ? historyDayOffset(today, -1) : today,
            ),
    );
    _refresh();
  }

  int? get _selectedPeriod {
    if (dates == null) return 30;
    final today = cairoToday();
    if (dates!.end == today && dates!.start == today) return 1;
    if (dates!.end == today && dates!.start == historyDayOffset(today, -6)) {
      return 7;
    }
    final yesterday = historyDayOffset(today, -1);
    if (dates!.start == yesterday && dates!.end == yesterday) return -1;
    return null;
  }

  Future<void> _pickDates() async {
    final today = cairoToday(), first = historyDayOffset(cairoToday(), -29);
    final valid =
        dates != null &&
        !dates!.start.isBefore(first) &&
        !dates!.end.isAfter(today);
    final selection = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: today,
      initialDateRange: valid ? dates : null,
      currentDate: today,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'اختر الفترة',
      saveText: 'تطبيق',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
      builder: (context, child) => Localizations.override(
        context: context,
        locale: const Locale('ar'),
        delegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: Builder(
          builder: (localizedContext) => Theme(
            data: _calendarTheme(localizedContext, first, today),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          ),
        ),
      ),
    );
    if (selection != null && mounted) {
      setState(() => dates = selection);
      _refresh();
    }
  }

  ThemeData _calendarTheme(
    BuildContext context,
    DateTime first,
    DateTime last,
  ) {
    final theme = _theme(context);
    final strings = MaterialLocalizations.of(context);
    final style = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
    );
    final labels = [
      strings.dateRangeStartLabel,
      strings.dateRangeEndLabel,
      strings.formatShortMonthDay(first),
      strings.formatShortMonthDay(last),
      strings.formatShortDate(first),
      strings.formatShortDate(last),
    ];
    double measure(String text) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.rtl,
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    // Flutter's range header uses an unwrapped Row. Fit only its date headline;
    // calendar controls and the rest of the screen retain the user's text scale.
    final width = MediaQuery.sizeOf(context).width;
    final available = math.max(1.0, width - (width < 360 ? 42 : 72) - 24);
    final required = labels.map(measure).reduce(math.max) * 2 + measure(' – ');
    final size = 20 * math.min(1.0, available / required);
    return theme.copyWith(
      datePickerTheme: theme.datePickerTheme.copyWith(
        rangePickerHeaderHeadlineStyle: style.copyWith(
          fontSize: size.toDouble(),
        ),
      ),
    );
  }

  Future<void> _pickEmployee() async {
    if (employeesLoading) return;
    if (employeeError != null) {
      await _loadEmployees();
      if (!mounted || employeeError != null) return;
    }
    if (!mounted) return;
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Theme(
          data: _theme(context),
          child: HistoryEmployeePicker(
            employees: employees,
            selected: employee,
          ),
        ),
      ),
    );
    if (selected != null &&
        mounted &&
        (selected == 0 ? null : selected) != employee) {
      setState(() => employee = selected == 0 ? null : selected);
      _refresh();
    }
  }

  String get employeeName {
    if (employee == null) return 'كل الموظفين';
    final matches = employees.where((item) => item.id == employee);
    return matches.isEmpty ? 'موظف محدد' : matches.first.name;
  }

  String _job(int id) {
    final matches = employees.where((item) => item.id == id);
    return matches.isEmpty ? '' : matches.first.job;
  }

  String get _periodLabel {
    final start = dates == null ? cubit.from : historyDate(dates!.start);
    final end = dates == null ? cubit.to : historyDate(dates!.end);
    if (start == null || end == null) return 'آخر ٣٠ يومًا';
    if (start == end) return historyDisplayDate(start);
    return '${historyDisplayDate(start)} — ${historyDisplayDate(end)}';
  }

  ThemeData _theme(BuildContext context) => Theme.of(context).copyWith(
    colorScheme: Theme.of(
      context,
    ).colorScheme.copyWith(primary: AppColors.primary, surface: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: historyInk,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    dividerColor: historyBorder,
    datePickerTheme: const DatePickerThemeData(
      rangePickerHeaderHeadlineStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      rangePickerHeaderHelpStyle: TextStyle(fontSize: 11),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (!UserHelper.isManager || !UserHelper.isLoggedIn) {
      return const Scaffold(body: Center(child: Text('هذه الصفحة للمدير فقط')));
    }
    return Theme(
      data: _theme(context),
      child: Scaffold(
        backgroundColor: historyCanvas,
        appBar: AppBar(
          title: Text(
            widget.daily ? 'سجل الحضور والتقارير' : 'سجل تقارير الموظفين',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              tooltip: 'تحديث السجل',
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded, size: 22),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: BlocBuilder<ManagerHistoryCubit, HistoryState>(
            bloc: cubit,
            builder: (context, state) => RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: scroll,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _summary(state),
                          const SizedBox(height: 14),
                          _filters(),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.daily
                                      ? 'السجل اليومي'
                                      : 'التقارير المقدمة',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: historyInk,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if ((!state.loading && state.error == null) ||
                                  state.rows.isNotEmpty)
                                Text(
                                  '${state.rows.length} من ${state.total}',
                                  style: const TextStyle(
                                    color: historyMuted,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.daily
                                ? 'كل نتيجة تمثل موظفًا في يوم واحد. عدم تسجيل الحضور لا يعني بالضرورة الغياب.'
                                    : 'راجع التقارير المؤكدة والمعلقة، وعدّل البيانات أو أكّد التقارير المعلقة.',
                            style: const TextStyle(
                              color: historyMuted,
                              fontSize: 11,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                  if (state.error != null && state.rows.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _message(error: true, message: state.error!),
                    )
                  else if (state.rows.isEmpty && !state.loading)
                    SliverFillRemaining(hasScrollBody: false, child: _message())
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final row = state.rows[index];
                          final showDate =
                              index == 0 ||
                              state.rows[index - 1].date != row.date;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDate)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: index == 0 ? 0 : 10,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 13,
                                        color: historyMuted,
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        child: Text(
                                          historyDisplayDate(
                                            row.date,
                                            weekday: true,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: historyMuted,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(color: historyBorder),
                                      ),
                                    ],
                                  ),
                                ),
                              HistoryEntryCard(
                                key: ValueKey(
                                  widget.daily
                                      ? '${row.employeeId}:${row.date}'
                                      : 'report:${row.report!.id}',
                                ),
                                row: row,
                                daily: widget.daily,
                                job: _job(row.employeeId),
                                onOpenReport:
                                    row.hasReport && row.report != null
                                    ? () => _openReport(row)
                                    : null,
                              ),
                            ],
                          );
                        }, childCount: state.rows.length),
                      ),
                    ),
                    if (state.loading)
                      SliverToBoxAdapter(
                        child: state.rows.isEmpty
                            ? _loading()
                            : const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    if (state.error != null && state.rows.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _retryBanner(state.error!),
                        ),
                      ),
                    if (state.more && !state.loading && state.error == null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                          child: OutlinedButton.icon(
                            onPressed: cubit.loadMore,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                              side: const BorderSide(color: historyBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.expand_more),
                            label: const Text('تحميل المزيد من السجل'),
                          ),
                        ),
                      ),
                    if (!state.more && !state.loading && state.rows.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 28),
                          child: Center(
                            child: Text(
                              'نهاية السجل · اسحب للأسفل للتحديث',
                              style: TextStyle(
                                fontSize: 11,
                                color: historyMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(HistoryState state) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF015C92), Color(0xFF157CAB)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.daily
                    ? Icons.event_available_outlined
                    : Icons.description_outlined,
                color: Colors.white.withValues(alpha: .9),
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                widget.daily ? 'متابعة يومية لفريقك' : 'تقارير فريقك بوضوح',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.daily
                    ? 'الحضور والانصراف وحالة تقديم التقرير'
                    : 'راجع تفاصيل العمل وحالة تأكيد كل تقرير',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .85),
                  fontSize: 11,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                state.rows.isEmpty && (state.loading || state.error != null)
                    ? '—'
                    : '${state.total}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.daily ? 'سجل يومي' : 'تقرير',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .9),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _filters() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: historyBorder),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.tune_rounded, size: 17, color: AppColors.primary),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'تصفية السجل',
                style: TextStyle(
                  fontSize: 12,
                  color: historyInk,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (employee != null || dates != null)
              TextButton(
                onPressed: _reset,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(48, 32),
                ),
                child: const Text(
                  'مسح التصفية',
                  style: TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final fields = [
              _filterField(
                key: const ValueKey('history-employee-filter'),
                label: 'الموظف',
                value: employeesLoading ? 'جارٍ تحميل الفريق…' : employeeName,
                icon: Icons.person_outline_rounded,
                busy: employeesLoading,
                onTap: _pickEmployee,
              ),
              _filterField(
                key: const ValueKey('history-date-filter'),
                label: 'الفترة',
                value: _periodLabel,
                icon: Icons.date_range_outlined,
                onTap: _pickDates,
              ),
            ];
            return constraints.maxWidth < 310 ||
                    MediaQuery.textScalerOf(context).scale(1) > 1.3
                ? Column(
                    children: [fields[0], const SizedBox(height: 8), fields[1]],
                  )
                : Row(
                    children: [
                      Expanded(child: fields[0]),
                      const SizedBox(width: 8),
                      Expanded(child: fields[1]),
                    ],
                  );
          },
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final period in [
                (1, 'اليوم'),
                (-1, 'أمس'),
                (7, '٧ أيام'),
                (30, '٣٠ يومًا'),
              ])
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 7),
                  child: ChoiceChip(
                    label: Text(period.$2),
                    selected: _selectedPeriod == period.$1,
                    onSelected: (_) {
                      if (_selectedPeriod != period.$1) {
                        _selectPeriod(period.$1);
                      }
                    },
                    showCheckmark: false,
                    selectedColor: const Color(0xFFEAF3FA),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: _selectedPeriod == period.$1
                          ? AppColors.primary.withValues(alpha: .3)
                          : historyBorder,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedPeriod == period.$1
                          ? AppColors.primary
                          : historyMuted,
                      fontSize: 11,
                      fontWeight: _selectedPeriod == period.$1
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Icon(Icons.info_outline, size: 12, color: historyMuted),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                'آخر ٣٠ يومًا فقط، بتوقيت القاهرة',
                style: TextStyle(fontSize: 10, color: historyMuted),
              ),
            ),
          ],
        ),
        if (employeeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _retryBanner(employeeError!, employeeList: true),
          ),
      ],
    ),
  );

  Widget _filterField({
    Key? key,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool busy = false,
  }) => Material(
    color: historyCanvas,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      key: key,
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: historyMuted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: historyInk,
                    ),
                  ),
                ],
              ),
            ),
            if (busy)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              )
            else
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: historyMuted,
              ),
          ],
        ),
      ),
    ),
  );

  Widget _message({bool error = false, String? message}) {
    final noTeam = employeesLoaded && employees.isEmpty && employee == null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: error ? const Color(0xFFFFF4E8) : const Color(0xFFE8F1F8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              error
                  ? Icons.wifi_off_rounded
                  : noTeam
                  ? Icons.groups_2_outlined
                  : widget.daily
                  ? Icons.event_note_outlined
                  : Icons.find_in_page_outlined,
              size: 32,
              color: error ? const Color(0xFF986617) : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            error
                ? 'تعذر تحميل السجل'
                : noTeam
                ? 'لا يوجد موظفون في فريقك حاليًا'
                : widget.daily
                ? 'لا توجد سجلات لهذه الفترة'
                : 'لا توجد تقارير مقدمة',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: historyInk,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message ??
                (noTeam
                    ? 'ستظهر السجلات هنا عند إسناد موظفين إليك.'
                    : 'جرّب اختيار فترة أخرى أو عرض كل الموظفين. يمكنك أيضًا السحب للأسفل للتحديث.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: historyMuted,
              fontSize: 12,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 18),
          if (error)
            FilledButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('إعادة المحاولة'),
            )
          else if (employee != null || dates != null)
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
              label: const Text('عرض السجل الكامل'),
            ),
        ],
      ),
    );
  }

  Future<void> _retry() async {
    final first = historyDate(historyDayOffset(cairoToday(), -29));
    if (cubit.from != null && cubit.from!.compareTo(first) < 0) {
      setState(() => dates = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('بدأ يوم جديد؛ تم تحديث الفترة المتاحة.')),
      );
      await _refresh();
    } else {
      await cubit.loadMore();
    }
  }

  Widget _retryBanner(String message, {bool employeeList = false}) => Container(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF7EB),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: Color(0xFF986617), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(fontSize: 11, color: Color(0xFF986617)),
          ),
        ),
        TextButton(
          onPressed: employeeList ? _loadEmployees : _retry,
          child: const Text('إعادة المحاولة', style: TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
  Widget _loading() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        for (var i = 0; i < 2; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: historyBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: historyCanvas,
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: historyCanvas,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: historyCanvas,
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
