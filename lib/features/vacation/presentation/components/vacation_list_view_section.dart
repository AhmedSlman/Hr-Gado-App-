import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_request_list_item_widget.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/features/vacation/logic/vacation_states.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';

class VacationListViewSection extends StatelessWidget {
  const VacationListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    Color _parseColor(String hex) {
      if (hex.isEmpty) return AppColors.grayText;
      final value = int.tryParse(hex.replaceFirst('#', '0xff'));
      return value != null ? Color(value) : AppColors.grayText;
    }

    return Expanded(
      child: BlocConsumer<VacationCubit, VacationStates>(
        buildWhen: (prev, curr) =>
            curr is VacationLoading ||
            curr is VacationLoadSuccess ||
            curr is VacationLoadError,
        listener: (context, state) {
          if (state is VacationLoadError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final response = state is VacationLoadSuccess ? state.response : null;
          final leaves = response?.leaves ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12),
            itemCount: leaves.length,
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
    );
  }
}
