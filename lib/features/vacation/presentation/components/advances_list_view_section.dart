import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/features/vacation/logic/vacation_states.dart';
import 'package:hr_app/features/vacation/presentation/widgets/advance_request_value_list_item_widget.dart';

class AdvancesListViewSection extends StatelessWidget {
  const AdvancesListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<VacationCubit, VacationStates>(
        buildWhen: (prev, curr) =>
            curr is AdvanceLoading ||
            curr is AdvanceLoadSuccess ||
            curr is AdvanceLoadError,
        listener: (context, state) {
          if (state is AdvanceLoadError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          final response = state is AdvanceLoadSuccess ? state.response : null;
          final advances = response?.advances ?? [];
          if (state is AdvanceLoading && advances.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12),
            itemCount: advances.length,
            itemBuilder: (context, index) {
              final it = advances[index];
              return AdvanceRequestValueListItemWidget(
                titleDateText: it.date,
                amountText: it.amount.toString(),
                statusText: it.statusLabel,
              );
            },
          );
        },
      ),
    );
  }
}
