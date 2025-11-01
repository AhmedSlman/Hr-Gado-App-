import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/features/notifications/router/notifications_names.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
    required this.userName,
    required this.profileImage,
    required this.role,
  });
  final String userName;
  final String profileImage;
  final String role;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: AppAssets.imageNetwork(
          profileImage.isNotEmpty
              ? profileImage
              : 'https://via.placeholder.com/50',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(userName, style: AppStyles.s14Medium),
      subtitle: Text(role, style: AppStyles.s12),
      trailing: InkWell(
        onTap: () {
          context.push(NotificationsRoutes.notifications);
        },
        child: AppAssets.svg(IconsAssets.notification),
      ),
    );
  }
}
