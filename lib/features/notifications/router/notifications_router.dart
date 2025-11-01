import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/locator/service_locator.dart';
import '../logic/notifications_cubit.dart';
import '../presentation/views/notifications_view.dart';
import 'notifications_names.dart';

class NotificationsRouter {
  static List<GoRoute> get routes => [
        GoRoute(
          path: NotificationsRoutes.notifications,
          builder: (context, state) {
            final cubit = sl<NotificationsCubit>()..getNotifications();
            return BlocProvider<NotificationsCubit>.value(
              value: cubit,
              child: const NotificationsView(),
            );
          },
        ),
      ];
}

