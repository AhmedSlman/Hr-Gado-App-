import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/components/employee_report_details_section.dart';
import 'package:hr_app/features/account/presentation/widgets/edit_report_modal.dart';

class EmployeeReportDetailsView extends StatelessWidget {
  final int reportId;

  const EmployeeReportDetailsView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {
        if (state is ConfirmReportSuccess) {
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          ).then((_) {
            context.pop();
          });
        }
        if (state is ConfirmReportError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      buildWhen: (previous, current) =>
          current is EmployeeReportDetailsLoadSuccess,
      builder: (context, state) {
        EmployeeReportDetailsModel? reportData;
        if (state is EmployeeReportDetailsLoadSuccess) {
          reportData = state.data;
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                const CustomAppBar(title: ''),
                Expanded(
                  child: EmployeeReportDetailsSection(
                    reportId: reportId,
                    onEditPressed: () {
                      _showEditReportModal(
                        context,
                        editType: EditReportType.devicesAndMeters,
                        reportData: reportData,
                      );
                    },
                    onConfirmPressed: () {
                      sl<AccountCubit>().confirmReport(reportId);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditReportModal(
    BuildContext context, {
    required EditReportType editType,
    EmployeeReportDetailsModel? reportData,
  }) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider<AccountCubit>.value(
        value: sl<AccountCubit>(),
        child: EditReportModal(
          editType: editType,
          reportId: reportId,
          reportData: reportData,
        ),
      ),
    );
  }
}
