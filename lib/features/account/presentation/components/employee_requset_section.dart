import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/account/data/models/employee_request_type.dart';
import 'package:hr_app/features/account/data/models/response/advance_details_model.dart';
import 'package:hr_app/features/account/data/models/response/vacation_details_model.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/components/long_term_advance_request_section.dart';
import 'package:hr_app/features/account/presentation/components/normal_advance_request_section.dart';
import 'package:hr_app/features/account/presentation/components/vacation_request_section.dart';
import 'package:hr_app/features/account/presentation/widgets/profile_picture_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/requset_actions_buttons.dart';

class EmployeeRequestSection extends StatelessWidget {
  final EmployeeRequestType requestType;
  final int requestId;

  const EmployeeRequestSection({
    super.key,
    required this.requestType,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          (requestType == EmployeeRequestType.vacation
              ? (current is VacationDetailsLoading ||
                    current is VacationDetailsLoadSuccess ||
                    current is VacationDetailsLoadError ||
                    current is ApproveLeaveProcessing ||
                    current is RejectLeaveProcessing)
              : (current is AdvanceDetailsLoading ||
                    current is AdvanceDetailsLoadSuccess ||
                    current is AdvanceDetailsLoadError ||
                    current is ApproveAdvanceProcessing ||
                    current is RejectAdvanceProcessing)) ||
          (requestType == EmployeeRequestType.vacation
              ? (current is ApproveLeaveProcessing ||
                    current is RejectLeaveProcessing)
              : (current is ApproveAdvanceProcessing ||
                    current is RejectAdvanceProcessing)),
      listener: (context, state) {
        if (state is VacationDetailsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is AdvanceDetailsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        // Vacation/Leave approval and rejection
        if (state is ApproveLeaveSuccess) {
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          ).then((_) {
            context.pop();
          });
        }
        if (state is ApproveLeaveError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is RejectLeaveSuccess) {
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          ).then((_) {
            context.pop();
          });
        }
        if (state is RejectLeaveError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        // Advance approval and rejection
        if (state is ApproveAdvanceSuccess) {
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          ).then((_) {
            context.pop();
          });
        }
        if (state is ApproveAdvanceError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is RejectAdvanceSuccess) {
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          ).then((_) {
            context.pop();
          });
        }
        if (state is RejectAdvanceError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = requestType == EmployeeRequestType.vacation
            ? (state is VacationDetailsLoading ||
                  state is ApproveLeaveProcessing ||
                  state is RejectLeaveProcessing)
            : (state is AdvanceDetailsLoading ||
                  state is ApproveAdvanceProcessing ||
                  state is RejectAdvanceProcessing);

        if (isLoading &&
            !(state is VacationDetailsLoadSuccess ||
                state is AdvanceDetailsLoadSuccess)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (requestType == EmployeeRequestType.vacation &&
            state is VacationDetailsLoadSuccess) {
          final data = state.data;
          return _buildVacationContent(context, data);
        }

        if (requestType != EmployeeRequestType.vacation &&
            state is AdvanceDetailsLoadSuccess) {
          final data = state.data;
          return _buildAdvanceContent(context, data);
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }

  Widget _buildVacationContent(
    BuildContext context,
    VacationDetailsModel data,
  ) {
    return BlocBuilder<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is ApproveLeaveProcessing ||
          current is RejectLeaveProcessing ||
          current is ApproveLeaveSuccess ||
          current is RejectLeaveSuccess ||
          current is ApproveLeaveError ||
          current is RejectLeaveError,
      builder: (context, actionState) {
        final isProcessing =
            actionState is ApproveLeaveProcessing ||
            actionState is RejectLeaveProcessing;

        return Column(
          children: [
            SizedBox(height: 24.h),
            ProfilePictureWidget(imageUrl: data.employee.image),
            SizedBox(height: 12.h),
            Text(
              data.employee.name,
              style: AppStyles.s18Bold.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 4.h),
            Text(
              data.employee.job,
              style: AppStyles.s14.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 32.h),
            VacationRequestSection(data: data),
            SizedBox(height: 32.h),
            RequsetActionsButtons(
              onAcceptPressed: isProcessing
                  ? null
                  : () {
                      sl<AccountCubit>().approveLeave(requestId);
                    },
              onRejectPressed: isProcessing
                  ? null
                  : () {
                      sl<AccountCubit>().rejectLeave(requestId);
                    },
            ),
            SizedBox(height: 32.h),
          ],
        );
      },
    );
  }

  Widget _buildAdvanceContent(BuildContext context, AdvanceDetailsModel data) {
    return BlocBuilder<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is ApproveAdvanceProcessing ||
          current is RejectAdvanceProcessing ||
          current is ApproveAdvanceSuccess ||
          current is RejectAdvanceSuccess ||
          current is ApproveAdvanceError ||
          current is RejectAdvanceError,
      builder: (context, actionState) {
        final isProcessing =
            actionState is ApproveAdvanceProcessing ||
            actionState is RejectAdvanceProcessing;

        return Column(
          children: [
            SizedBox(height: 24.h),
            ProfilePictureWidget(imageUrl: data.employee.image),
            SizedBox(height: 12.h),
            Text(
              data.employee.name,
              style: AppStyles.s18Bold.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 4.h),
            Text(
              data.employee.job,
              style: AppStyles.s14.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 32.h),
            _buildAdvanceRequestContent(context, data),
            SizedBox(height: 32.h),
            RequsetActionsButtons(
              onAcceptPressed: isProcessing
                  ? null
                  : () {
                      sl<AccountCubit>().approveAdvance(requestId);
                    },
              onRejectPressed: isProcessing
                  ? null
                  : () {
                      sl<AccountCubit>().rejectAdvance(requestId);
                    },
            ),
            SizedBox(height: 32.h),
          ],
        );
      },
    );
  }

  Widget _buildAdvanceRequestContent(
    BuildContext context,
    AdvanceDetailsModel data,
  ) {
    switch (requestType) {
      case EmployeeRequestType.vacation:
        return const SizedBox.shrink();
      case EmployeeRequestType.normalAdvance:
        return NormalAdvanceRequestSection(
          amount: data.amount,
          latestAdvanceDate: data.stats?.latestAdvanceDate ?? '',
        );
      case EmployeeRequestType.longTermAdvance:
        return LongTermAdvanceRequestSection(
          amount: data.amount,
          numberOfMonths: data.numberOfMonths ?? 0,
        );
    }
  }
}
