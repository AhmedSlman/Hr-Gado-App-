import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_report_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';
import 'package:hr_app/features/account/router/account_route_extra.dart';

class EmployeeReportsListSection extends StatelessWidget {
  const EmployeeReportsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is EmployeeReportsLoading ||
          current is EmployeeReportsLoadSuccess ||
          current is EmployeeReportsLoadError,
      listener: (context, state) {
        if (state is EmployeeReportsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is EmployeeReportsLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is EmployeeReportsLoadSuccess) {
          final reports = state.response.reports;

          if (reports.isEmpty) {
            return const Expanded(
              child: Center(child: Text('لا توجد تقارير')),
            );
          }

          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return EmployeeReportCardWidget(
                  report: report,
                  onTap: () {
                    context.push(
                      AccountRoutes.employeeReportDetails,
                      extra: EmployeeReportDetailsExtra(reportId: report.id),
                    );
                  },
                );
              },
            ),
          );
        }

        return const Expanded(
          child: Center(child: Text('لا توجد بيانات')),
        );
      },
    );
  }
}


