import '../../../salary/presentation/widgets/report_metric_labels.dart';
import '../../../salary/data/models/response/report_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/person_data_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_acctions_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_date_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_details_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/report_row_card_widget.dart';

class EmployeeReportDetailsSection extends StatelessWidget {
  final int reportId;
  final VoidCallback? onEditPressed;
  final VoidCallback? onConfirmPressed;

  const EmployeeReportDetailsSection({
    super.key,
    required this.reportId,
    this.onEditPressed,
    this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is EmployeeReportDetailsLoading ||
          current is EmployeeReportDetailsLoadSuccess ||
          current is EmployeeReportDetailsLoadError,
      listener: (context, state) {
        if (state is EmployeeReportDetailsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is EmployeeReportDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeReportDetailsLoadSuccess) {
          final data = state.data;
          return _buildContent(context, data);
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }

  Widget _buildContent(BuildContext context, EmployeeReportDetailsModel data) {
    return BlocBuilder<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is UpdateReportProcessing ||
          current is UpdateReportSuccess ||
          current is UpdateReportError ||
          current is ConfirmReportProcessing ||
          current is ConfirmReportSuccess ||
          current is ConfirmReportError,
      builder: (context, state) {
        final isUpdatingState = state is UpdateReportProcessing;
        final isConfirmingState = state is ConfirmReportProcessing;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.h),
              PersonDataWidget(
                employeeName: data.employeeName,
                jobTitle: data.employeeJob,
                profileImageUrl: data.employeeImage,
              ),
              SizedBox(height: 32.h),
              ReportDate(date: data.date),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _buildReportStats(data),
              ),
              SizedBox(height: 24.h),
              // Report content
              ReportDetailsWidget(report: data.content),
              SizedBox(height: 32.h),
              ReportActionsWidget(
                onEditPressed: isUpdatingState || isConfirmingState
                    ? null
                    : onEditPressed,
                onConfirmPressed: isUpdatingState || isConfirmingState
                    ? null
                    : onConfirmPressed,
                isUpdating: isUpdatingState,
                isConfirming: isConfirmingState,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportStats(EmployeeReportDetailsModel data) {
    final metrics = displayReportMetrics(data.metrics);
    return Column(
      children: [
        for (final entry in metrics.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReportRowCardWidget(
              title: reportMetricLabels[entry.key] ?? entry.key,
              value: entry.value,
            ),
          ),
      ],
    );
  }
}
