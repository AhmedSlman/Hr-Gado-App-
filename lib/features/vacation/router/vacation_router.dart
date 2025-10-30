import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_app/features/vacation/logic/vacation_cubit.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/vacation/presentation/views/vacation_requests_view.dart';
import 'package:hr_app/features/vacation/presentation/views/advance_requests_view.dart';
import 'vacation_names.dart';
import '../presentation/views/vacation_view.dart';

class VacationRouter {
  static List<GoRoute> get routes => [
    // Vacation Screen
    GoRoute(
      path: VacationRoutes.vacation,
      builder: (context, state) => BlocProvider<VacationCubit>(
        create: (_) {
          final cubit = sl<VacationCubit>();
          cubit.loadVacations();
          cubit.loadAdvances();
          return cubit;
        },
        child: const VacationAdvanceView(),
      ),
    ),
    // Vacation Requests List Screen
    GoRoute(
      path: VacationRoutes.vacationRequests,
      builder: (context, state) => BlocProvider.value(
        value: BlocProvider.of<VacationCubit>(context),
        child: const VacationRequestsView(),
      ),
    ),
    // Advance Requests List Screen
    GoRoute(
      path: VacationRoutes.advanceRequests,
      builder: (context, state) => const AdvanceRequestsView(),
    ),
  ];
}
