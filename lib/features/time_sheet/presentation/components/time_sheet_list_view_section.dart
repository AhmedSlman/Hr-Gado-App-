import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/core/common/widgets/custom_snackbar.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_cubit.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_states.dart';
import 'package:hr_app/features/time_sheet/presentation/widgets/time_sheet_item_widget.dart';

class TimeSheetListViewSection extends StatelessWidget {
  const TimeSheetListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimeSheetCubit, TimeSheetStates>(
      buildWhen: (previous, current) =>
          current is TimeSheetLoading ||
          current is TimeSheetLoadSuccess ||
          current is TimeSheetLoadError,
      listener: (context, state) {
        if (state is TimeSheetLoadError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is TimeSheetLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TimeSheetLoadSuccess) {
          final items = state.items;

          if (items.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return TimeSheetItemWidget(
                date: item.date,
                checkInTime: item.attendance,
                checkOutTime: item.departure,
              );
            },
          );
        }

        return const Center(child: Text('لا توجد بيانات'));
      },
    );
  }
}
