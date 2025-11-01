import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_app_bar.dart';
import 'package:hr_app/features/account/presentation/components/employee_report_details_section.dart';
import 'package:hr_app/features/account/presentation/widgets/edit_report_modal.dart';

class EmployeeReportDetailsView extends StatelessWidget {
  final int reportId;

  const EmployeeReportDetailsView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            const CustomAppBar(title: ''),
            Expanded(
              child: EmployeeReportDetailsSection(
                onEditPressed: () {
                  _showEditReportModal(
                    context,
                    editType: EditReportType.devicesAndMeters,
                  );
                },
                onConfirmPressed: () {
                  // Handle confirm
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditReportModal(
    BuildContext context, {
    required EditReportType editType,
  }) {
    showDialog(
      context: context,
      builder: (context) => EditReportModal(editType: editType),
    );
  }
}

