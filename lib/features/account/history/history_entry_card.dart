import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'manager_history.dart';

const historyCanvas = Color(0xFFF4F7FB);
const historyBorder = Color(0xFFE5EDF4);
const historyMuted = Color(0xFF6B7C8F);
const historyInk = Color(0xFF172D43);
const historyMonths = [
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
const historyWeekdays = [
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

String historyDisplayDate(
  String value, {
  bool weekday = false,
  bool year = false,
}) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return '${weekday ? '${historyWeekdays[date.weekday - 1]}، ' : ''}${date.day} ${historyMonths[date.month - 1]}${year ? ' ${date.year}' : ''}';
}

class HistoryStatus extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  const HistoryStatus({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}

class HistoryEntryCard extends StatefulWidget {
  final HistoryRow row;
  final bool daily;
  final String job;
  final VoidCallback? onOpenReport;
  const HistoryEntryCard({
    super.key,
    required this.row,
    required this.daily,
    this.job = '',
    this.onOpenReport,
  });
  @override
  State<HistoryEntryCard> createState() => _HistoryEntryCardState();
}

class _HistoryEntryCardState extends State<HistoryEntryCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final report = row.hasReport ? row.report : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: historyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFEAF3FA),
                      foregroundColor: AppColors.primary,
                      radius: 22,
                      child: Text(
                        row.name.trim().isEmpty
                            ? '؟'
                            : row.name.trim().characters.first,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: historyInk,
                            ),
                          ),
                          if (widget.job.isNotEmpty)
                            Text(
                              widget.job,
                              style: const TextStyle(
                                color: historyMuted,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!widget.daily && report != null)
                      Text(
                        '#${report.id}',
                        style: const TextStyle(
                          color: historyMuted,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (report != null)
                      HistoryStatus(
                        text: report.confirmed
                            ? 'تقرير مؤكد'
                            : 'بانتظار تأكيد التقرير',
                        color: report.confirmed
                            ? const Color(0xFF16836C)
                            : const Color(0xFF986617),
                        icon: report.confirmed
                            ? Icons.verified_outlined
                            : Icons.pending_outlined,
                      )
                    else
                      const HistoryStatus(
                        text: 'لم يُقدم تقرير',
                        color: Color(0xFF986617),
                        icon: Icons.description_outlined,
                      ),
                    if (widget.daily &&
                        row.hasAttendance &&
                        row.attendance?['status'] != null)
                      HistoryStatus(
                        text: _attendanceStatus(row.attendance!['status']),
                        color: row.attendance!['status'] == 0
                            ? const Color(0xFF16836C)
                            : const Color(0xFF986617),
                        icon: Icons.schedule_outlined,
                      ),
                  ],
                ),
                if (widget.daily) ...[
                  const SizedBox(height: 12),
                  _attendance(row),
                ],
                if (!widget.daily && report != null && !expanded) ...[
                  const SizedBox(height: 12),
                  Text(
                    report.content.isEmpty
                        ? 'لا يوجد نص إضافي للتقرير'
                        : report.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.7,
                      color: historyMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (report != null) ...[
            if (widget.onOpenReport != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: OutlinedButton.icon(
                  key: ValueKey('manage-report-${report.id}'),
                  onPressed: widget.onOpenReport,
                  icon: Icon(
                    report.confirmed
                        ? Icons.edit_outlined
                        : Icons.fact_check_outlined,
                    size: 18,
                  ),
                  label: Text(
                    report.confirmed
                        ? 'تعديل التقرير'
                        : 'تعديل أو تأكيد التقرير',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: historyBorder),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(color: historyBorder, height: 1),
                          const SizedBox(height: 16),
                          const Text(
                            'تفاصيل التقرير',
                            style: TextStyle(
                              color: historyInk,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            report.content.isEmpty
                                ? 'لا يوجد نص إضافي للتقرير'
                                : report.content,
                            style: const TextStyle(
                              color: historyInk,
                              fontSize: 13,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _metricGrid(report),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: ValueKey(
                  'expand-${widget.daily ? '${row.employeeId}-${row.date}' : report.id}',
                ),
                onPressed: () => setState(() => expanded = !expanded),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                icon: Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                label: Text(
                  expanded ? 'إخفاء التفاصيل' : 'عرض التقرير والبيانات',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _attendance(HistoryRow row) {
    if (!row.hasAttendance) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: historyCanvas,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.event_busy_outlined, color: historyMuted, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'لا يوجد سجل حضور',
                style: TextStyle(fontSize: 12, color: historyMuted),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: historyCanvas,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MediaQuery.textScalerOf(context).scale(1) > 1.3
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _time(
                  'الحضور',
                  row.attendance?['check_in_at'],
                  row.date,
                  Icons.login_rounded,
                ),
                const Divider(color: historyBorder, height: 24),
                _time(
                  'الانصراف',
                  row.attendance?['check_out_at'],
                  row.date,
                  Icons.logout_rounded,
                ),
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _time(
                      'الحضور',
                      row.attendance?['check_in_at'],
                      row.date,
                      Icons.login_rounded,
                    ),
                  ),
                  const VerticalDivider(color: historyBorder, width: 24),
                  Expanded(
                    child: _time(
                      'الانصراف',
                      row.attendance?['check_out_at'],
                      row.date,
                      Icons.logout_rounded,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _time(String label, dynamic raw, String workDate, IconData icon) {
    final date = DateTime.tryParse(raw?.toString() ?? '');
    final time = date == null
        ? 'غير مسجل'
        : '${(date.hour % 12 == 0 ? 12 : date.hour % 12).toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'ص' : 'م'}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: historyMuted),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: historyMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: date == null ? historyMuted : historyInk,
          ),
        ),
        if (date != null && historyDate(date) != workDate)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              historyDisplayDate(historyDate(date)),
              style: const TextStyle(fontSize: 10, color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _metricGrid(HistoryReport report) {
    final values = historyMetricsForJob(report, widget.job);
    if (values.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final entry in values.entries)
            Container(
              width: (constraints.maxWidth - 8) / 2,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: historyCanvas,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metricLabels[entry.key]!,
                    style: const TextStyle(fontSize: 11, color: historyMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.value % 1 == 0
                        ? entry.value.toInt().toString()
                        : entry.value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _attendanceStatus(dynamic value) => switch (value) {
    0 => 'حضور في الموعد',
    1 => 'حضور متأخر',
    2 => 'حضور مبكر',
    _ => 'حضور مسجل',
  };
}

Map<String, num> historyMetricsForJob(HistoryReport report, String job) {
  final metrics = report.metrics;
  final keys = switch (job.trim().toLowerCase()) {
    'driver' ||
    'سائق' => ['installation_devices', 'supply_devices', 'overtime_hours'],
    'technician' || 'فني' => ['num_of_devices', 'num_of_meters'],
    'sales' ||
    'مبيعات' => ['sold_devices', 'bought_devices', 'commercial_devices'],
    _ =>
      metrics.keys
          .where(
            (key) =>
                metrics[key] != 0 &&
                (key != 'num_of_devices' ||
                    metrics['installation_devices'] != metrics[key]),
          )
          .toList(),
  };
  return {for (final key in keys) key: metrics[key] ?? 0};
}
