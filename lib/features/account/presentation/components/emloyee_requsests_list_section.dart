import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/account/data/models/employee_request_type.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/employee_request_card_widget.dart';
import 'package:hr_app/features/account/router/account_names.dart';
import 'package:hr_app/features/account/router/account_route_extra.dart';

class EmployeeRequsetsListViewSection extends StatelessWidget {
  const EmployeeRequsetsListViewSection({super.key});

  EmployeeRequestType _parseRequestType(String type) {
    switch (type) {
      case 'leave':
        return EmployeeRequestType.vacation;
      case 'advance':
        // Default to normal, can be enhanced later if API provides more info
        return EmployeeRequestType.normalAdvance;
      default:
        return EmployeeRequestType.vacation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      buildWhen: (previous, current) =>
          current is EmployeeRequestsLoading ||
          current is EmployeeRequestsLoadSuccess ||
          current is EmployeeRequestsLoadError,
      listener: (context, state) {
        if (state is EmployeeRequestsLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is EmployeeRequestsLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is EmployeeRequestsLoadSuccess) {
          final requests = state.response.requests;

          if (requests.isEmpty) {
            return const Expanded(child: Center(child: Text('لا توجد طلبات')));
          }

          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final requestType = _parseRequestType(request.type);

                return EmployeeRequestCardWidget(
                  employeeName: request.employeeName,
                  date: request.date,
                  requestType: request.typeName,
                  details: request.details,
                  onTap: () {
                    context.push(
                      AccountRoutes.employeeRequestDetails,
                      extra: EmployeeRequestDetailsExtra(
                        requestType: requestType,
                        requestId: request.id,
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const Expanded(child: Center(child: Text('لا توجد بيانات')));
      },
    );
  }
}
