import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/components/employee_report_details_section.dart';
import 'package:hr_app/features/account/presentation/widgets/edit_report_modal.dart';

class EmployeeReportDetailsView extends StatelessWidget {
  final int reportId;
  final bool isConfirmed;

  const EmployeeReportDetailsView({
    super.key,
    required this.reportId,
    this.isConfirmed = false,
  });

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
            if (context.mounted) context.pop();
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
                    canApprove: !isConfirmed,
                    onEditPressed: reportData == null
                        ? null
                        : () {
                            _showEditReportModal(
                              context,
                              reportData: reportData!,
                            );
                          },
                    onConfirmPressed: () async {
                      final approved = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('تأكيد التقرير؟'),
                          content: const Text(
                            'تأكد من مراجعة بيانات التقرير قبل تأكيده.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('إلغاء'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('تأكيد'),
                            ),
                          ],
                        ),
                      );
                      if (approved == true && context.mounted) {
                        await context.read<AccountCubit>().confirmReport(
                          reportId,
                        );
                      }
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

  Future<void> _showEditReportModal(
    BuildContext context, {
    required EmployeeReportDetailsModel reportData,
  }) async {
    final cubit = context.read<AccountCubit>();
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<AccountCubit, AccountStates>(
          builder: (context, state) => PopScope(
            canPop: state is! UpdateReportProcessing,
            child: EditReportModal(reportId: reportId, reportData: reportData),
          ),
        ),
      ),
    );
    if (!cubit.isClosed && saved == true) {
      await cubit.loadEmployeeReportDetails(reportId);
    }
  }
}
