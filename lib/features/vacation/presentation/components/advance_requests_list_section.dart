import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_request_value_list_item_widget.dart';
import 'package:hr_app/features/vacation/presentation/views/advance_requests_view.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/features/vacation/logic/vacation_states.dart';

class AdvanceRequestsListSection extends StatelessWidget {
  const AdvanceRequestsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    String _statusText(String label) => label;
    Color _statusColor(String hex) {
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
                'طلبات السلفة السابقة',
                style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdvanceRequestsView(),
                    ),
                  );
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
        BlocConsumer<VacationCubit, VacationStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final advances = state is AdvanceLoadSuccess
                ? state.response.advances
                : <dynamic>[];
            final count = advances.length > 2 ? 2 : advances.length;
            return ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                final it = advances[index];
                return AdvanceRequestValueListItemWidget(
                  titleDateText: it.date,
                  amountText: it.amount.toString(),
                  statusText: _statusText(it.statusLabel),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
