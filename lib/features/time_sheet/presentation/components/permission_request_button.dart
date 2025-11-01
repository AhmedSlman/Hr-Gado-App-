import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_cubit.dart';
import 'package:hr_app/features/time_sheet/presentation/components/permission_request_dialog_section.dart';

class PermissionRequestButton extends StatelessWidget {
  PermissionRequestButton({super.key});

  void _showPermissionRequestDialog(BuildContext context) {
    final cubit = sl<TimeSheetCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider<TimeSheetCubit>.value(
          value: cubit,
          child: PermissionRequestDialogComponent(
            delayDurations: _delayDurations,
          ),
        );
      },
    );
  }

  final List<String> _delayDurations = [
    "15 دقيقة",
    "30 دقيقة",
    "45 دقيقة",
    "ساعة واحدة",
    "ساعة ونصف",
    "ساعتين",
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: "طلب إذن",
          onPressed: () => _showPermissionRequestDialog(context),
          height: 56,
          leadingIcon: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: AppColors.primary),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
