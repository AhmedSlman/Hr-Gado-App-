import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/validation/form_validator.dart';
import 'package:hr_app/features/auth/presentation/widgets/forget_pass_dialog.dart';
import 'package:hr_app/features/auth/logic/auth_cubit.dart';
import 'package:hr_app/features/auth/logic/auth_states.dart';
import 'package:hr_app/features/auth/presentation/widgets/auth_text_form_field.dart';

class ForgetPasswrodSection extends StatefulWidget {
  const ForgetPasswrodSection({super.key});

  @override
  State<ForgetPasswrodSection> createState() => _ForgetPasswrodSectionState();
}

class _ForgetPasswrodSectionState extends State<ForgetPasswrodSection> {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccess) {
          // Clear field after success
          usernameController.clear();
          // Show empty dialog
          ForgetPassDialog.show(
            context: context,
            onClose: () {
              Navigator.of(context).pop();
            },
          );
        } else if (state is AuthError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              AuthTextFormField(
                title: "إسم المستخدم",
                hint: "أدخل اسم المستخدم",
                controller: usernameController,
                validator: (value) =>
                    FormValidator.validateRequired(value, "اسم المستخدم"),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: state is AuthLoading ? "جاري الإرسال..." : "إرسال الطلب",
                onPressed: state is AuthLoading ? () {} : _sendResetRequest,
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendResetRequest() {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      AuthCubit.get(context).forgotPassword(username);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
