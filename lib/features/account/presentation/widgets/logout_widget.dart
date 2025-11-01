import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/common/widgets/custom_button.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/auth/logic/auth_cubit.dart';
import 'package:hr_app/features/auth/logic/auth_states.dart';
import 'package:hr_app/features/auth/router/auth_names.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthLogoutSuccess) {
            CustomSnackBar.showSuccess(context, message: state.message);
            // Navigate to login page
            context.go(AuthRoutes.login);
          } else if (state is AuthLogoutError) {
            CustomSnackBar.showError(context, message: state.message);
            // Even if logout API failed, navigate to login since local data is cleared
            context.go(AuthRoutes.login);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLogoutLoading;

          return InkWell(
            onTap: isLoading
                ? null
                : () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (dialogContext) => Dialog(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close icon
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.grayText,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Title
                              Text(
                                'تأكيد تسجيل الخروج',
                                style: AppStyles.s20Medium.copyWith(
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              // Message
                              Text(
                                'هل أنت متأكد من تسجيل الخروج؟',
                                style: AppStyles.s14Medium.copyWith(
                                  color: AppColors.grayText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: 'إلغاء',
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      backgroundColor: AppColors.grayText,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: CustomButton(
                                      text: 'تسجيل خروج',
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        context.read<AuthCubit>().logout();
                                      },
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 24.sp,
                      height: 24.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.logout, color: AppColors.primary, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'تسجيل خروج',
                    style: AppStyles.s16Medium.copyWith(
                      color: isLoading
                          ? AppColors.primary.withOpacity(0.6)
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
