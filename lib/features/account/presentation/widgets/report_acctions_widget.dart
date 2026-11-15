import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/app_colors.dart';

class ReportActionsWidget extends StatelessWidget {
  const ReportActionsWidget({
    super.key,
    required this.onEditPressed,
    required this.onConfirmPressed,
    this.isUpdating = false,
    this.isConfirming = false,
    this.showConfirm = true,
  });
  final VoidCallback? onEditPressed, onConfirmPressed;
  final bool isUpdating, isConfirming, showConfirm;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final busy = isUpdating || isConfirming;
        final edit = OutlinedButton(
          onPressed: busy ? null : onEditPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: isUpdating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('تعديل التقرير', textAlign: TextAlign.center),
        );
        final approve = FilledButton(
          onPressed: busy ? null : onConfirmPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: isConfirming
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('تأكيد التقرير', textAlign: TextAlign.center),
        );
        if (!showConfirm) return edit;
        if (constraints.maxWidth < 400 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.3) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [edit, const SizedBox(height: 10), approve],
          );
        }
        return Row(
          children: [
            Expanded(child: edit),
            const SizedBox(width: 12),
            Expanded(child: approve),
          ],
        );
      },
    ),
  );
}
