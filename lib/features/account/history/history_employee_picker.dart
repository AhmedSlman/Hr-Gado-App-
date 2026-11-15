import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/response/employee_model.dart';
import 'history_entry_card.dart';

class HistoryEmployeePicker extends StatefulWidget {
  final List<EmployeeModel> employees;
  final int? selected;
  const HistoryEmployeePicker({
    super.key,
    required this.employees,
    this.selected,
  });
  @override
  State<HistoryEmployeePicker> createState() => _HistoryEmployeePickerState();
}

class _HistoryEmployeePickerState extends State<HistoryEmployeePicker> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    final results = widget.employees
        .where(
          (employee) =>
              employee.name.toLowerCase().contains(
                search.trim().toLowerCase(),
              ) ||
              employee.job.toLowerCase().contains(search.trim().toLowerCase()),
        )
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .72,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: historyBorder,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'اختر الموظف',
                        style: TextStyle(
                          color: historyInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'إغلاق',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 21),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  key: const ValueKey('history-employee-search'),
                  onChanged: (value) => setState(() => search = value),
                  decoration: InputDecoration(
                    hintText: 'ابحث بالاسم أو الوظيفة',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: historyCanvas,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    if (search.trim().isEmpty) _option(null),
                    for (final employee in results) _option(employee),
                    if (results.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.person_search_outlined,
                              color: historyMuted,
                              size: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.employees.isEmpty
                                  ? 'لا يوجد موظفون في الفريق حاليًا'
                                  : 'لا يوجد موظف يطابق البحث',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: historyMuted),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(EmployeeModel? employee) {
    final selected = employee?.id == widget.selected;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      leading: CircleAvatar(
        backgroundColor: selected
            ? AppColors.primary.withValues(alpha: .1)
            : historyCanvas,
        foregroundColor: AppColors.primary,
        child: Icon(
          employee == null ? Icons.groups_2_outlined : Icons.person_outline,
          size: 22,
        ),
      ),
      title: Text(
        employee?.name ?? 'كل الموظفين',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: historyInk,
        ),
      ),
      subtitle: employee == null
          ? const Text(
              'عرض سجل الفريق بالكامل',
              style: TextStyle(fontSize: 11, color: historyMuted),
            )
          : (employee.job.isEmpty
                ? null
                : Text(
                    employee.job,
                    style: const TextStyle(fontSize: 11, color: historyMuted),
                  )),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
        color: selected ? AppColors.primary : historyBorder,
        size: 22,
      ),
      onTap: () => Navigator.pop(context, employee?.id ?? 0),
    );
  }
}
