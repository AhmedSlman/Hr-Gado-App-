import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/meetings/presentation/widgets/success_create_meeting_dialog.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/common/widgets/custom_text_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/request/create_meeting_request.dart';
import '../../data/models/response/employee_model.dart';
import '../../logic/meetings_cubit.dart';
import '../../logic/meetings_states.dart';
import '../widgets/employee_chip.dart';

class AddMeetingBodySection extends StatefulWidget {
  const AddMeetingBodySection({super.key});

  @override
  State<AddMeetingBodySection> createState() => _AddMeetingBodySectionState();
}

class _AddMeetingBodySectionState extends State<AddMeetingBodySection> {
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  final Set<int> _selectedEmployeeIds = <int>{};
  EmployeesResponse? _employeesResponse;

  @override
  void initState() {
    super.initState();
    MeetingsCubit.get(context).getEmployees();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      _timeController.text = '$hour:$minute';
      setState(() {});
    }
  }

  void _openEmployeesBottomSheet(List<EmployeeData> employees) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('اختر الموظفين', style: AppStyles.subHeader),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 320.h,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: employees
                          .map(
                            (e) => EmployeeChip(
                              name: e.name,
                              image: e.image,
                              selected: _selectedEmployeeIds.contains(e.id),
                              onTap: () {
                                setState(() {
                                  if (_selectedEmployeeIds.contains(e.id)) {
                                    _selectedEmployeeIds.remove(e.id);
                                  } else {
                                    _selectedEmployeeIds.add(e.id);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  text: 'تم',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final request = CreateMeetingRequest(
      title: _titleController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      link: _linkController.text.trim(),
      participants: _selectedEmployeeIds.toList(),
    );
    MeetingsCubit.get(context).createMeeting(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeetingsCubit, MeetingsStates>(
      listener: (context, state) {
        if (state is EmployeesSuccess) {
          _employeesResponse = state.employeesResponse;
        }
        if (state is EmployeesError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is CreateMeetingSuccess) {
          CustomSnackBar.showSuccess(context, message: state.message);
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => SuccessCreateMeetingDialog(message: state.message),
          ).then((_) {
            // After dialog closes (auto after 10s or by user), go back to meetings screen
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
        if (state is CreateMeetingError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isCreating = state is CreateMeetingLoading;
        final employees = _employeesResponse?.data ?? [];
        final firstThree = employees.take(3).toList();
        final remaining = employees.length > 3
            ? employees.sublist(3)
            : <EmployeeData>[];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حدد تاريخ الاجتماع',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText: 'اختر التاريخ',
                    controller: _dateController,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'حدد وقت الاجتماع',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickTime,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText: 'اختر الوقت',
                    controller: _timeController,
                    suffixIcon: const Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'عنوان الاجتماع',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                hintText: 'اكتب عنوان للاجتماع',
                controller: _titleController,
              ),
              SizedBox(height: 16.h),

              Text(
                'رابط الاجتماع',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                hintText: 'ادخل الرابط',
                controller: _linkController,
              ),
              SizedBox(height: 20.h),

              Text(
                'اضافة الموظفين للاجتماع',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 12.h),

              Wrap(
                spacing: 12.w,
                children: [
                  ...firstThree.map(
                    (e) => EmployeeChip(
                      name: e.name,
                      image: e.image,
                      selected: _selectedEmployeeIds.contains(e.id),
                      onTap: () {
                        setState(() {
                          if (_selectedEmployeeIds.contains(e.id)) {
                            _selectedEmployeeIds.remove(e.id);
                          } else {
                            _selectedEmployeeIds.add(e.id);
                          }
                        });
                      },
                    ),
                  ),
                  if (remaining.isNotEmpty)
                    GestureDetector(
                      onTap: () => _openEmployeesBottomSheet(employees),
                      child: CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AppColors.fillGrey,
                        child: const Icon(Icons.add, color: AppColors.primary),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 24.h),
              CustomButton(
                text: 'تأكيد',
                isLoading: isCreating,
                onPressed: isCreating ? null : _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
