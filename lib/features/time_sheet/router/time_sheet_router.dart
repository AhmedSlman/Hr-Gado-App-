import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/time_sheet/logic/time_sheet_cubit.dart';
import 'time_sheet_names.dart';
import '../presentation/views/time_sheet_view.dart';

class TimeSheetRouter {
  static List<GoRoute> get routes => [
    // TimeSheet Screen
    GoRoute(
      path: TimeSheetRoutes.timeSheet,
      builder: (context, state) {
        final cubit = sl<TimeSheetCubit>();
        // Load initial data for current month
        final now = DateTime.now();
        cubit.loadItems(month: now.month, year: now.year);
        return BlocProvider<TimeSheetCubit>.value(
          value: cubit,
          child: const TimeSheetView(),
        );
      },
    ),
  ];
}
