import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/meetings/logic/meetings_cubit.dart';
import 'package:hr_app/features/meetings/router/meetings_names.dart';

import '../presentation/views/add_meeting_view.dart';
import '../presentation/views/meetings_view.dart';

class MeetingsRouter {
  static List<GoRoute> get routes => [
    // Meetings Screen
    GoRoute(
      path: MeetingsRoutes.meetings,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<MeetingsCubit>()..getMyMeetings(),
        child: const MeetingsView(),
      ),
    ),
    // Add Meeting Screen (Manager only)
    GoRoute(
      path: MeetingsRoutes.addMeeting,
      redirect: (context, state) {
        // Only managers can access this page
        if (!UserHelper.isManager) {
          // Redirect to meetings page if not manager
          return MeetingsRoutes.meetings;
        }
        return null;
      },
      builder: (context, state) => BlocProvider(
        create: (context) => sl<MeetingsCubit>()..getEmployees(),
        child: const AddMeetingView(),
      ),
    ),
  ];
}
