import 'package:flutter/material.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/time_sheet/presentation/components/permission_request_dialog_section.dart';

class PermissionRequestButton extends StatelessWidget {
  PermissionRequestButton({super.key});

  void _showPermissionRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PermissionRequestDialogComponent(
          delayDurations: _delayDurations,
          onRequestSubmitted: () => _showSuccessDialog(context),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SuccessDialogWidget(
          title: "تم إرسال الطلب بنجاح",
          message:
              "نقدر حرصك على إبلاغ الإدارة مسبقًا، وسيتم النظر فيه خلال وقت قصير.",
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
