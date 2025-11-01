import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_balance_item_widget.dart';
import 'package:hr_app/features/account/presentation/widgets/leave_request_field_widget.dart';

class VacationRequestSection extends StatelessWidget {
  const VacationRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Leave balance section
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازات',
          value: '21 يوم',
          showDivider: false,
        ),
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازة المستهلكة',
          value: '9 ايام',
        ),
        LeaveBalanceItemWidget(
          label: 'عدد ايام الاجازة المتبقية',
          value: '12 يوم',
          isRemaining: true,
          showDivider: false,
        ),
        SizedBox(height: 24.h),
        // Leave request details section
        LeaveRequestFieldWidget(
          label: 'تاريخ بداية الاجازة',
          value: '8 يناير 2025',
        ),
        LeaveRequestFieldWidget(
          label: 'تاريخ نهاية الاجازة',
          value: '15 يناير 2025',
        ),
        LeaveRequestFieldWidget(
          label: 'عدد الايام المطلوبة',
          value: '3',
          isDaysField: true,
        ),
      ],
    );
  }
}

