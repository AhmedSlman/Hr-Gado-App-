import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/response/employee_report_details_model.dart';
import '../../logic/account_cubit.dart';
import '../../logic/account_states.dart';
import '../../../home/presentation/widgets/report_number_field.dart';
import '../../../salary/data/models/response/api_values.dart';
import '../../../salary/presentation/widgets/report_metric_labels.dart';

class EditReportModal extends StatefulWidget {
  final int reportId;
  final EmployeeReportDetailsModel reportData;
  const EditReportModal({
    super.key,
    required this.reportId,
    required this.reportData,
  });
  @override
  State<EditReportModal> createState() => _EditReportModalState();
}

class _EditReportModalState extends State<EditReportModal> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _content;
  late final Map<String, String> _values;
  @override
  void initState() {
    super.initState();
    _content = TextEditingController(text: widget.reportData.content);
    _values = {
      for (final entry in widget.reportData.metrics.entries)
        entry.key: entry.value == null
            ? ''
            : formatSalaryNumber(entry.value!.toDouble()),
    };
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    final changes = <String, dynamic>{};
    if (_content.text != widget.reportData.content)
      changes['content'] = _content.text;
    for (final entry in _values.entries) {
      if (entry.value.isEmpty) continue;
      final value = apiNumber(entry.value);
      if (value != widget.reportData.metrics[entry.key]) {
        changes[entry.key] = entry.key.contains('devices')
            ? apiCount(entry.value)
            : value;
      }
    }
    if (changes.isEmpty) {
      Navigator.of(context).pop(false);
      return;
    }
    context.read<AccountCubit>().updateReport(widget.reportId, changes);
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<AccountCubit, AccountStates>(
    listener: (context, state) {
      if (state is UpdateReportSuccess) Navigator.of(context).pop(true);
    },
    builder: (context, state) {
      final busy = state is UpdateReportProcessing;
      return AlertDialog(
        title: const Text('تعديل التقرير'),
        content: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in _values.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: entry.key == 'overtime_hours'
                        ? DropdownButtonFormField<String>(
                            initialValue: entry.value.isEmpty
                                ? null
                                : entry.value,
                            decoration: const InputDecoration(
                              labelText: 'ساعات العمل الإضافية',
                            ),
                            items: [
                              for (final value in {
                                ...List.generate(12, (i) => '$i'),
                                if (entry.value.isNotEmpty) entry.value,
                              })
                                DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                            ],
                            onChanged: busy
                                ? null
                                : (value) => _values[entry.key] = value ?? '',
                          )
                        : ReportNumberField(
                            label: reportMetricLabels[entry.key] ?? entry.key,
                            initialValue: entry.value,
                            decimal: entry.key == 'num_of_meters',
                            onChanged: (value) => _values[entry.key] = value,
                            optional: true,
                          ),
                  ),
                TextFormField(
                  controller: _content,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'تقرير العمل'),
                ),
                if (state is UpdateReportError)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: busy ? null : _submit,
            child: Text(busy ? 'جارٍ الحفظ' : 'حفظ'),
          ),
        ],
      );
    },
  );
}
