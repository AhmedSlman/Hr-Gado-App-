import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import 'package:hr_app/features/meetings/logic/meetings_cubit.dart';

import '../presentation/views/add_meeting_view.dart';
import '../presentation/views/meetings_view.dart';
import 'meetings_names.dart';

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
    // Add Meeting Screen
    GoRoute(
      path: MeetingsRoutes.addMeeting,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<MeetingsCubit>()..getEmployees(),
        child: const AddMeetingView(),
      ),
    ),
  ];
}
