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
  final VoidCallback? onEditPressed;
  final VoidCallback? onConfirmPressed;

  const EmployeeReportDetailsSection({
    super.key,
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
            onEditPressed: onEditPressed,
            onConfirmPressed: onConfirmPressed,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildReportStats(EmployeeReportDetailsModel data) {
    final stats = <Widget>[];

    // Type 3: devices + meters
    if (data.numOfDevices != null && data.numOfMeters != null) {
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الاجهزة',
          value: data.displayDevices ?? '0',
        ),
      );
      stats.add(SizedBox(height: 12.h));
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الامتار',
          value: data.displayMeters ?? '0',
        ),
      );
    }
    // Type 1: devices + overtime
    else if (data.numOfDevices != null && data.overtimeHours != null) {
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الاجهزة',
          value: data.displayDevices ?? '0',
        ),
      );
      stats.add(SizedBox(height: 12.h));
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الساعات',
          value: data.displayHours ?? '0',
        ),
      );
    }
    // Type 2: sold + bought + commercial devices
    else if (data.soldDevices != null &&
        data.boughtDevices != null &&
        data.commercialDevices != null) {
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الاجهزة المباعة',
          value: data.soldDevices.toString(),
        ),
      );
      stats.add(SizedBox(height: 12.h));
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الاجهزة المشتراة',
          value: data.boughtDevices.toString(),
        ),
      );
      stats.add(SizedBox(height: 12.h));
      stats.add(
        ReportRowCardWidget(
          title: 'عدد الاجهزة التجارية',
          value: data.commercialDevices.toString(),
        ),
      );
    }
    // Alternative format: addition + addition_overtime
    else if (data.addition != null && data.additionOvertime != null) {
      stats.add(
        ReportRowCardWidget(
          title: data.addition!,
          value: data.additionOvertime.toString(),
        ),
      );
    }
    // Fallback: show available data
    else {
      if (data.displayDevices != null) {
        stats.add(
          ReportRowCardWidget(
            title: 'عدد الاجهزة',
            value: data.displayDevices!,
          ),
        );
      }
      if (data.displayMeters != null) {
        if (stats.isNotEmpty) stats.add(SizedBox(height: 12.h));
        stats.add(
          ReportRowCardWidget(title: 'عدد الامتار', value: data.displayMeters!),
        );
      }
      if (data.displayHours != null) {
        if (stats.isNotEmpty) stats.add(SizedBox(height: 12.h));
        stats.add(
          ReportRowCardWidget(title: 'عدد الساعات', value: data.displayHours!),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: stats,
    );
  }
}
