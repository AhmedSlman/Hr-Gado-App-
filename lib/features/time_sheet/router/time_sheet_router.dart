import 'package:go_router/go_router.dart';
import 'time_sheet_names.dart';
import '../presentation/views/time_sheet_view.dart';

class TimeSheetRouter {
  static List<GoRoute> get routes => [
    // TimeSheet Screen
    GoRoute(
      path: TimeSheetRoutes.timeSheet,
      builder: (context, state) => const TimeSheetView(),
    ),
  ];
}
