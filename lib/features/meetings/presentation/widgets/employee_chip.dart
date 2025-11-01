import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class EmployeeChip extends StatelessWidget {
  final String name;
  final String image;
  final bool selected;
  final VoidCallback onTap;

  const EmployeeChip({
    super.key,
    required this.name,
    required this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.fillGrey,
                    width: selected ? 3 : 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26.r,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              if (selected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12.r,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 72.w,
          child: Text(
            name,
            style: AppStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.grayText,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
