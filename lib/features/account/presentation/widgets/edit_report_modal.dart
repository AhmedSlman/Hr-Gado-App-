import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/data/models/response/employee_report_details_model.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';

enum EditReportType {
  devicesAndMeters, // عدد الأجهزة والأمتار
  achievedGoals, // الأهداف المحققة
}

class EditReportModal extends StatefulWidget {
  final EditReportType editType;
  final int reportId;
  final EmployeeReportDetailsModel? reportData;

  const EditReportModal({
    super.key,
    required this.editType,
    required this.reportId,
    this.reportData,
  });

  @override
  State<EditReportModal> createState() => _EditReportModalState();
}

class _EditReportModalState extends State<EditReportModal> {

  late TextEditingController _devicesController;
  late TextEditingController _metersController;
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _devicesController = TextEditingController(
      text: widget.reportData?.displayDevices ?? '',
    );
    _metersController = TextEditingController(
      text: widget.reportData?.displayMeters ?? '',
    );
    _contentController = TextEditingController(
      text: widget.reportData?.content ?? '',
    );
  }

  @override
  void dispose() {
    _devicesController.dispose();
    _metersController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountStates>(
      listener: (context, state) {
        if (state is UpdateReportSuccess) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => SuccessDialogWidget(
              title: 'تم بنجاح',
              message: state.message,
            ),
          ).then((_) {
            // Refresh report details
            context.read<AccountCubit>().loadEmployeeReportDetails(widget.reportId);
          });
        }
        if (state is UpdateReportError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is UpdateReportProcessing) {
          setState(() => _isLoading = true);
        } else if (state is UpdateReportSuccess || state is UpdateReportError) {
          setState(() => _isLoading = false);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'تعديل التقرير',
                      textAlign: TextAlign.center,
                      style: AppStyles.s18Bold.copyWith(color: AppColors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.grayText,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Content based on edit type
              _buildContent(context),
              SizedBox(height: 24.h),
              // Send button
              CustomButton(
                text: 'ارسال',
                onPressed: _isLoading ? null : () => _handleSubmit(context),
                height: 50.h,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    final formData = <String, dynamic>{};

    // Add content if available
    if (_contentController.text.isNotEmpty) {
      formData['content'] = _contentController.text;
    }

    // Add devices and meters for Type 3
    if (widget.editType == EditReportType.devicesAndMeters) {
      if (_devicesController.text.isNotEmpty) {
        formData['num_of_devices'] = _devicesController.text;
      }
      if (_metersController.text.isNotEmpty) {
        formData['num_of_meters'] = _metersController.text;
      }
    }

    context.read<AccountCubit>().updateReport(widget.reportId, formData);
  }

  Widget _buildContent(BuildContext context) {
    switch (widget.editType) {
      case EditReportType.devicesAndMeters:
        return _buildDevicesAndMetersContent();
      case EditReportType.achievedGoals:
        return _buildAchievedGoalsContent();
    }
  }

  Widget _buildDevicesAndMetersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number of devices field
        Text(
          'عدد الاجهزة',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _devicesController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'اختر عدد الأجهزة',
              hintStyle: AppStyles.s16.copyWith(color: AppColors.grayText),
            ),
            style: AppStyles.s16.copyWith(color: AppColors.black),
          ),
        ),
        SizedBox(height: 16.h),
        // Number of meters field
        Text(
          'عدد الامتار',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _metersController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'اختر عدد الامتار',
              hintStyle: AppStyles.s16.copyWith(color: AppColors.grayText),
            ),
            style: AppStyles.s16.copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievedGoalsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Achieved goals label
        Text(
          'الأهداف المحققة',
          style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
        // Text input field
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.lightBlue, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _contentController,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'اكتب الأهداف المحققة',
              hintStyle: AppStyles.s16.copyWith(color: AppColors.grayText),
            ),
            style: AppStyles.s16.copyWith(color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
