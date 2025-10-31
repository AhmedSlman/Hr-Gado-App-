import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/meetings/presentation/widgets/add_meeting_button.dart';

import '../../logic/salary_deduction_cubit.dart';
import '../../logic/salary_deduction_states.dart';
import '../../router/salary_deduction_names.dart';
import '../widgets/deduction_card.dart';

class ManagerDeductionsBodySection extends StatelessWidget {
  const ManagerDeductionsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            AddButton(
              title: 'اضافة جزاء',
              onTap: () async {
                final result = await context.push<bool>(
                  SalaryDeductionRoutes.addDeduction,
                );
                if (result == true) {
                  SalaryDeductionCubit.get(context).getManagerDeductions();
                }
              },
            ),

            SizedBox(height: 20.h),
            BlocBuilder<SalaryDeductionCubit, SalaryDeductionStates>(
              builder: (context, state) {
                if (state is SalaryDeductionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SalaryDeductionError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'حدث خطأ: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            SalaryDeductionCubit.get(
                              context,
                            ).getManagerDeductions();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is SalaryDeductionSuccess) {
                  if (state.deductionsResponse.data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'لا توجد جزاءات',
                          style: AppStyles.body.copyWith(
                            color: AppColors.grayText,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final deduction = state.deductionsResponse.data[index];
                      return DeductionCard(deduction: deduction);
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemCount: state.deductionsResponse.data.length,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
