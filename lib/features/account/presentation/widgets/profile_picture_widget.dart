import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const ProfilePictureWidget({super.key, required this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Profile picture circle
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.fillGrey,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Icon(Icons.person, size: 60.sp, color: AppColors.greyIcon)
                : null,
          ),
          // Camera icon overlay
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: InkWell(
          //     onTap: onTap,
          //     child: Container(
          //       width: 40.w,
          //       height: 40.w,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppColors.lightBlue,
          //         border: Border.all(color: AppColors.white, width: 3),
          //       ),
          //       child: Icon(
          //         Icons.camera_alt,
          //         color: AppColors.white,
          //         size: 20.sp,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
