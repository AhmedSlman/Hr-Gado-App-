import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/news/presentation/widgets/success_create_news_dialog.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/common/widgets/custom_text_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/request/create_news_request.dart';
import '../../data/models/response/employee_model.dart';
import '../../logic/news_cubit.dart';
import '../../logic/news_states.dart';

class AddNewsBodySection extends StatefulWidget {
  const AddNewsBodySection({super.key});

  @override
  State<AddNewsBodySection> createState() => _AddNewsBodySectionState();
}

class _AddNewsBodySectionState extends State<AddNewsBodySection> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int _newsType = 0; // 0 = general, 1 = employee
  int? _selectedEmployeeId;
  int? _selectedDuration;
  EmployeesResponse? _employeesResponse;

  final List<int> _durationOptions = [1, 2, 3, 5, 6, 7, 10, 14, 30];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _loadEmployees() {
    NewsCubit.get(context).getEmployees();
  }

  void _submit() {
    if (_selectedDuration == null) {
      CustomSnackBar.showError(context, message: 'يرجى اختيار مدة الخبر');
      return;
    }
    if (_newsType == 1 && _selectedEmployeeId == null) {
      CustomSnackBar.showError(context, message: 'يرجى اختيار الموظف');
      return;
    }

    final request = CreateNewsRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      aboutEmployee: _newsType,
      employeeId: _newsType == 1 ? _selectedEmployeeId : null,
      durationInDays: _selectedDuration!,
    );
    NewsCubit.get(context).createNews(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {
        if (state is EmployeesSuccess) {
          _employeesResponse = state.employeesResponse;
        }
        if (state is EmployeesError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is CreateNewsSuccess) {
          CustomSnackBar.showSuccess(context, message: state.message);
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => SuccessCreateNewsDialog(message: state.message),
          ).then((_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
        if (state is CreateNewsError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isCreating = state is CreateNewsLoading;
        final isLoadingEmployees = state is EmployeesLoading;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Type
              Text(
                'اختر نوع الخبر',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text('اخبار عامة', style: AppStyles.s14Medium),
                      value: 0,
                      groupValue: _newsType,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _newsType = value!;
                          if (_newsType == 0) {
                            _selectedEmployeeId = null;
                          } else if (_newsType == 1 &&
                              _employeesResponse == null) {
                            _loadEmployees();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text('اخبار الموظفين', style: AppStyles.s14Medium),
                      value: 1,
                      groupValue: _newsType,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _newsType = value!;
                          if (_newsType == 1 && _employeesResponse == null) {
                            _loadEmployees();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Employee Name (conditional)
              if (_newsType == 1) ...[
                Text(
                  'اسم الموظف',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                isLoadingEmployees
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'جاري التحميل...',
                              style: AppStyles.body.copyWith(
                                color: AppColors.grayText,
                              ),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<int>(
                        initialValue: _selectedEmployeeId,
                        decoration: InputDecoration(
                          hintText: 'اختر الموظف',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5.w,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          isDense: true,
                        ),
                        items: (_employeesResponse?.data ?? []).map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee.id,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12.r,
                                  backgroundImage: NetworkImage(employee.image),
                                ),
                                SizedBox(width: 12.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        employee.name,
                                        style: AppStyles.body,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEmployeeId = value;
                          });
                        },
                      ),
                SizedBox(height: 16.h),
              ],

              // News Title
              Text(
                'عنوان الخبر',
                style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                hintText: 'ادخل العنوان',
                controller: _titleController,
              ),
              SizedBox(height: 16.h),

              // News Details
              Text(
                'تفاصيل الخبر',
                style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                hintText: 'ادخل الخبر',
                controller: _contentController,
                maxLines: 3,
              ),
              SizedBox(height: 16.h),

              // Duration
              Text(
                'مدة الخبر',
                style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<int>(
                initialValue: _selectedDuration,
                decoration: InputDecoration(
                  hintText: 'اختر المدة',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5.w,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  isDense: true,
                ),
                items: _durationOptions.map((duration) {
                  return DropdownMenuItem<int>(
                    value: duration,
                    child: Text('$duration يوم', style: AppStyles.body),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
              ),
              SizedBox(height: 24.h),

              // Submit Button
              CustomButton(
                text: 'اضافة الخبر',
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
