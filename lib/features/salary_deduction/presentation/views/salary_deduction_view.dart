import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/salary_deduction/logic/salary_deduction_cubit.dart';
import 'package:hr_app/features/salary_deduction/presentation/components/employee_deductions_body_section.dart';
import 'package:hr_app/features/salary_deduction/presentation/components/manager_deductions_body_section.dart';

class SalaryDeductionView extends StatefulWidget {
  const SalaryDeductionView({super.key});

  @override
  State<SalaryDeductionView> createState() => _SalaryDeductionViewState();
}

class _SalaryDeductionViewState extends State<SalaryDeductionView> {
  @override
  void initState() {
    super.initState();
    // Load data based on user role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserHelper.userRole == 'Manager') {
        SalaryDeductionCubit.get(context).getManagerDeductions();
      } else {
        SalaryDeductionCubit.get(context).getEmployeeDeductions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "الجزاءات"),
            Expanded(
              child: UserHelper.userRole == 'Manager'
                  ? const ManagerDeductionsBodySection()
                  : const EmployeeDeductionsBodySection(),
            ),
          ],
        ),
      ),
    );
  }
}
