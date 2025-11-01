import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/common/widgets/success_dialog_widget.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/account/logic/account_cubit.dart';
import 'package:hr_app/features/account/logic/account_states.dart';
import 'package:hr_app/features/account/presentation/widgets/complaints_text_field.dart';

class ComplaintFormSection extends StatefulWidget {
  const ComplaintFormSection({super.key});

  @override
  State<ComplaintFormSection> createState() => _ComplaintFormSectionState();
}

class _ComplaintFormSectionState extends State<ComplaintFormSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountStates>(
      listener: (context, state) {
        if (state is ReportIssueSuccess) {
          _controller.clear();
          showDialog(
            context: context,
            builder: (_) =>
                SuccessDialogWidget(title: 'تم بنجاح', message: state.message),
          );
        }
        if (state is ReportIssueError) {
          CustomSnackBar.showError(context, message: state.message);
        }
        if (state is ReportIssueProcessing) {
          setState(() => _isLoading = true);
        } else if (state is ReportIssueSuccess || state is ReportIssueError) {
          setState(() => _isLoading = false);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            ComlaintsTextFormField(controller: _controller),
            SizedBox(height: 32.h),
            // Send button
            CustomButton(
              text: 'ارسال',
              onPressed: _isLoading ? null : _handleSubmit,
              height: 50.h,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      CustomSnackBar.showError(
        context,
        message: 'الرجاء إدخال الشكوى أو الاقتراح',
      );
      return;
    }

    final formData = {'content': content};
    sl<AccountCubit>().reportIssue(formData);
  }
}
