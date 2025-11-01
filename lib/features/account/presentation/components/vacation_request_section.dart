import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/account/data/models/response/vacation_details_model.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_balance_item_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_request_field_widget.dart';

class VacationRequestSection extends StatelessWidget {
  final VacationDetailsModel data;

  const VacationRequestSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Leave balance section
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازات',
          value: '${data.stats.allowedOffDays} يوم',
          showDivider: false,
        ),
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازة المستهلكة',
          value: '${data.stats.usedOffDays} ايام',
        ),
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازة المتبقية',
          value: '${data.stats.remainingOffDays} يوم',
          isRemaining: true,
          showDivider: false,
        ),
        SizedBox(height: 24.h),
        // Leave request details section
        LeaveRequestFieldWidget(
          label: 'تاريخ بداية الاجازة',
          value: data.startDate,
        ),
        LeaveRequestFieldWidget(
          label: 'تاريخ نهاية الاجازة',
          value: data.endDate,
        ),
        LeaveRequestFieldWidget(
          label: 'عدد الايام المطلوبة',
          value: data.numberOfDays.toString(),
          isDaysField: true,
        ),
      ],
    );
  }
}

