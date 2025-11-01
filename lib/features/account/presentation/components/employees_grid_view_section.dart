import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';
import 'package:hr_app/features/account/router/account_route_extra.dart';

class EmployeesGridViewSection extends StatelessWidget {
  const EmployeesGridViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is EmployeesLoading ||
          current is EmployeesLoadSuccess ||
          current is EmployeesLoadError,
      listener: (context, state) {
        if (state is EmployeesLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is EmployeesLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is EmployeesLoadSuccess) {
          final employees = state.response.employees;

          if (employees.isEmpty) {
            return const Expanded(child: Center(child: Text('لا يوجد موظفين')));
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return EmployeeCardWidget(
                    name: employee.name,
                    role: employee.job,
                    imageUrl: employee.image.isNotEmpty ? employee.image : null,
                    onTap: () {
                      // Navigate to employee personal data with employee ID
                      context.push(
                        AccountRoutes.personalData,
                        extra: PersonalDataExtra(employeeId: employee.id),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }

        return const Expanded(child: Center(child: Text('لا توجد بيانات')));
      },
    );
  }
}
