import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/request/create_car_request.dart';
import '../../data/models/response/car_model.dart';
import '../../data/models/response/employee_model.dart';
import '../../logic/cars_cubit.dart';
import '../../logic/cars_states.dart';
import '../widgets/success_create_car_dialog.dart';

class AddCarBodySection extends StatefulWidget {
  final int? carId; // null for add, not null for edit
  final CarDetails? carData; // car data for edit mode

  const AddCarBodySection({super.key, this.carId, this.carData});

  @override
  State<AddCarBodySection> createState() => _AddCarBodySectionState();
}

class _AddCarBodySectionState extends State<AddCarBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _licenseIssueController = TextEditingController();
  final _licenseRenewalController = TextEditingController();
  final _lastOilChangeController = TextEditingController();
  final _nextOilChangeController = TextEditingController();

  int? _selectedEmployeeId;
  EmployeesResponse? _employeesResponse;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.carId != null;
    if (_isEditMode && widget.carData != null) {
      _populateFields();
    }
    CarsCubit.get(context).getEmployees();
  }

  void _populateFields() {
    final car = widget.carData!;
    _modelController.text = car.model;
    _licensePlateController.text = car.licensePlate;
    _licenseIssueController.text = car.licenseIssue;
    _licenseRenewalController.text = car.licenseRenewal;
    _lastOilChangeController.text = car.lastOilChange;
    _nextOilChangeController.text = car.nextOilChange;
    _selectedEmployeeId = car.employeeId;
  }

  @override
  void dispose() {
    _modelController.dispose();
    _licensePlateController.dispose();
    _licenseIssueController.dispose();
    _licenseRenewalController.dispose();
    _lastOilChangeController.dispose();
    _nextOilChangeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedEmployeeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار السائق')));
      return;
    }

    final request = CreateCarRequest(
      model: _modelController.text.trim(),
      licensePlate: _licensePlateController.text.trim(),
      licenseIssue: _licenseIssueController.text.trim(),
      licenseRenewal: _licenseRenewalController.text.trim(),
      lastOilChange: _lastOilChangeController.text.trim(),
      nextOilChange: _nextOilChangeController.text.trim(),
      employeeId: _selectedEmployeeId!,
    );

    if (_isEditMode) {
      CarsCubit.get(context).updateCar(widget.carId!, request);
    } else {
      CarsCubit.get(context).createCar(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarsCubit, CarsStates>(
      listener: (context, state) {
        if (state is EmployeesSuccess) {
          setState(() {
            _employeesResponse = state.employeesResponse;
            if (_isEditMode && _selectedEmployeeId == null) {
              _selectedEmployeeId = widget.carData?.employeeId;
            }
          });
        }
        if (state is CreateCarSuccess) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => SuccessCreateCarDialog(
              message: state.message,
              isEditMode: false,
            ),
          ).then((_) {
            // After dialog closes (auto after 10s or by user), go back to cars screen
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
        if (state is UpdateCarSuccess) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => SuccessCreateCarDialog(
              message: state.message,
              isEditMode: true,
            ),
          ).then((_) {
            // After dialog closes (auto after 10s or by user), go back to cars screen
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(true);
            }
          });
        }
      },
      builder: (context, state) {
        final isLoadingEmployees = state is EmployeesLoading;
        final isSubmitting =
            state is CreateCarLoading || state is UpdateCarLoading;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع السيارة
                Text(
                  'نوع السيارة',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hintText: 'ادخل نوع السيارة',
                  controller: _modelController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال نوع السيارة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // رقم السيارة
                Text(
                  'رقم السيارة',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hintText: 'ادخل رقم السيارة',
                  controller: _licensePlateController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال رقم السيارة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // تاريخ اصدار الرخصة
                Text(
                  'تاريخ اصدار الرخصة',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => _pickDate(_licenseIssueController),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: 'حدد التاريخ',
                      controller: _licenseIssueController,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى تحديد تاريخ اصدار الرخصة';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // تاريخ تجديد الرخصة
                Text(
                  'تاريخ تجديد الرخصة',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => _pickDate(_licenseRenewalController),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: 'حدد التاريخ',
                      controller: _licenseRenewalController,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى تحديد تاريخ تجديد الرخصة';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // تاريخ آخر تغيير زيت
                Text(
                  'تاريخ آخر تغيير زيت',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => _pickDate(_lastOilChangeController),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: 'حدد التاريخ',
                      controller: _lastOilChangeController,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى تحديد تاريخ آخر تغيير زيت';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // تاريخ تجديد الزيت
                Text(
                  'تاريخ تجديد الزيت',
                  style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => _pickDate(_nextOilChangeController),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: 'حدد التاريخ',
                      controller: _nextOilChangeController,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى تحديد تاريخ تجديد الزيت';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // اسم السائق
                Text(
                  'اسم السائق',
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
                          hintText: 'اختر السائق',
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
                          prefixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
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
                            return 'يرجى اختيار السائق';
                          }
                          return null;
                        },
                      ),
                SizedBox(height: 24.h),

                // Submit Button
                CustomButton(
                  text: _isEditMode ? 'تعديل' : 'اضافة السيارة',
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
