import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import '../../logic/rules_cubit.dart';
import '../../logic/rules_states.dart';

class CompanyRulesContentSection extends StatelessWidget {
  const CompanyRulesContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RulesCubit, RulesStates>(
      buildWhen: (previous, current) =>
          current is RulesLoading ||
          current is RulesLoadSuccess ||
          current is RulesLoadError,
      listener: (context, state) {
        if (state is RulesLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is RulesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RulesLoadSuccess) {
          final rules = state.rules;

          if (rules.isEmpty) {
            return const Center(child: Text('لا توجد قوانين'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...rules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final rule = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: _buildRuleItem(
                        number: index + 1,
                        text: rule.content,
                      ),
                    );
                  }),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }

  Widget _buildRuleItem({
    required int number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            '$number - $text',
            textAlign: TextAlign.right,
            style: AppStyles.s16.copyWith(
              color: AppColors.black,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

