import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_request_list_item_widget.dart';
import 'package:hr_app/features/vacation/router/vacation_names.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/features/vacation/logic/vacation_states.dart';

class VacationRequestsListSection extends StatelessWidget {
  const VacationRequestsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    Color _parseColor(String hex) {
      if (hex.isEmpty) return AppColors.grayText;
      final value = int.tryParse(hex.replaceFirst('#', '0xff'));
      return value != null ? Color(value) : AppColors.grayText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'طلبات الإجازة السابقة',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.go(VacationRoutes.vacationRequests);
                },
                child: Text(
                  'عرض الكل',
                  style: AppStyles.s12Medium.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: BlocConsumer<VacationCubit, VacationStates>(
            listener: (context, state) {
              if (state is VacationLoadError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final response = state is VacationLoadSuccess
                  ? state.response
                  : null;
              final leaves = response?.leaves ?? [];
              final count = leaves.length > 2 ? 2 : leaves.length;
              return ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) {
                  final it = leaves[index];
                  return VacationRequestListItemWidget(
                    titleDateText: it.date,
                    daysCountText: it.numOfDays,
                    rangeDateText: it.from,
                    statusText: it.statusLabel,
                    statusColor: _parseColor(it.statusColor),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
