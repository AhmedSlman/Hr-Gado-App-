import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:hr_app/features/auth/presentation/widgets/forget_password_text.dart';
import 'package:hr_app/features/auth/logic/auth_cubit.dart';
import 'package:hr_app/features/auth/logic/auth_states.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/features/auth/router/auth_names.dart';
import 'package:hr_app/features/bottom_navigation/router/main_page_names.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Save user data to UserHelper
          UserHelper.saveUser(state.user);

          // Clear text fields after successful login
          userNameController.clear();
          passwordController.clear();

          // Show success message
          CustomSnackBar.showSuccess(context, message: "تم تسجيل الدخول بنجاح");

          // Navigate to main page (bottom navbar)
          context.go(MainPageNames.mainPage);
        } else if (state is AuthError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextFormField(
                title: 'إسم المستخدم',
                hint: 'أدخل الاسم',
                controller: userNameController,
              ),
              AuthTextFormField(
                title: 'كلمة المرور',
                hint: 'أدخل كلمة المرور',
                controller: passwordController,
              ),
              ForgetPasswordText(
                onTap: () {
                  context.go(AuthRoutes.forgetPassword);
                },
              ),
              CustomButton(
                text: state is AuthLoading
                    ? "جاري تسجيل الدخول..."
                    : "تسجيل الدخول",
                onPressed: state is AuthLoading ? () {} : _login,
              ),
            ],
          ),
        );
      },
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      AuthCubit.get(
        context,
      ).login(userNameController.text, passwordController.text);
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
