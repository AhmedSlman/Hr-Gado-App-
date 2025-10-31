import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';

class EmployeeCardWidget extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;
  final VoidCallback? onTap;

  const EmployeeCardWidget({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          // Circular profile picture
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.fillGrey,
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.person, size: 40.sp, color: AppColors.greyIcon)
                : null,
          ),
          SizedBox(height: 4.h),
          // Name (bold, black)
          Text(
            name,
            style: AppStyles.s14Medium.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          // Role (gray)
          Text(
            role,
            style: AppStyles.s12.copyWith(color: AppColors.grayText),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
