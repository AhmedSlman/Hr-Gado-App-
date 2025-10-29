import 'package:go_router/go_router.dart';
import 'package:hr_app/features/vacation/presentation/views/vacation_requests_view.dart';
import 'package:hr_app/features/vacation/presentation/views/advance_requests_view.dart';
import 'vacation_names.dart';
import '../presentation/views/vacation_view.dart';

class VacationRouter {
  static List<GoRoute> get routes => [
    // Vacation Screen
    GoRoute(
      path: VacationRoutes.vacation,
      builder: (context, state) => const VacationView(),
    ),
    // Vacation Requests List Screen
    GoRoute(
      path: VacationRoutes.vacationRequests,
      builder: (context, state) => const VacationRequestsView(),
    ),
    // Advance Requests List Screen
    GoRoute(
      path: VacationRoutes.advanceRequests,
      builder: (context, state) => const AdvanceRequestsView(),
    ),
  ];
}
