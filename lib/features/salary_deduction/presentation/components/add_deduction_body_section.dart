import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/request/create_deduction_request.dart';
import '../../data/models/response/employee_model.dart';
import '../../logic/salary_deduction_cubit.dart';
import '../../logic/salary_deduction_states.dart';
import '../widgets/success_create_deduction_dialog.dart';

class AddDeductionBodySection extends StatefulWidget {
  const AddDeductionBodySection({super.key});

  @override
  State<AddDeductionBodySection> createState() =>
      _AddDeductionBodySectionState();
}

class _AddDeductionBodySectionState extends State<AddDeductionBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();

  int? _selectedEmployeeId;
  EmployeesResponse? _employeesResponse;

  @override
  void initState() {
    super.initState();
    SalaryDeductionCubit.get(context).getEmployees();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedEmployeeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار الموظف')));
      return;
    }

    if (_typeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال سبب الجزاء')));
      return;
    }

    final request = CreateDeductionRequest(
      amount: int.parse(_amountController.text.trim()),
      type: _typeController.text.trim(),
      employeeId: _selectedEmployeeId!,
    );

    SalaryDeductionCubit.get(context).createDeduction(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalaryDeductionCubit, SalaryDeductionStates>(
      listener: (context, state) {
        if (state is EmployeesSuccess) {
          setState(() {
            _employeesResponse = state.employeesResponse;
          });
        }
        if (state is CreateDeductionSuccess) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) =>
                SuccessCreateDeductionDialog(message: state.message),
          ).then((_) {
            // After dialog closes (auto after 10s or by user), go back
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
      },
      builder: (context, state) {
        final isLoadingEmployees = state is EmployeesLoading;
        final isSubmitting = state is CreateDeductionLoading;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الموظف
                Text(
                  'الموظف',
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
                          // prefixIcon: const Icon(
                          //   Icons.arrow_drop_down,
                          //   color: AppColors.primary,
                          // ),
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
                                  child: Text(
                                    employee.name,
                                    style: AppStyles.body,
                                    overflow: TextOverflow.ellipsis,
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
                        validator: (value) {
                          if (value == null) {
                            return 'يرجى اختيار الموظف';
                          }
                          return null;
                        },
                      ),
                SizedBox(height: 16.h),

                // سبب الجزاء
                Text(
                  'سبب الجزاء',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hintText: 'اختر السبب',
                  controller: _typeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال سبب الجزاء';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // المبلغ
                Text(
                  'المبلغ',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hintText: 'ادخل المبلغ',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال المبلغ';
                    }
                    final amount = int.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return 'يرجى إدخال مبلغ صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Submit Button
                CustomButton(
                  text: 'اضافة الجزاء',
                  isLoading: isSubmitting,
                  onPressed: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
