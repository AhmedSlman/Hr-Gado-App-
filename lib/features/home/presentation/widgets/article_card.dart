import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/core/utils/app_assets.dart';
import 'package:hr_app/features/home/data/models/response/home_screen_model.dart';

class ArticleCard extends StatelessWidget {
  final ArticleData article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(left: 12.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Info on Right
          if (article.employee != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: NetworkImage(article.employee!.image),
                    ),
                    if (article.aboutEmployee > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: SvgPicture.asset(
                          AppAssets.badge,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  article.employee!.name,
                  style: AppStyles.s12Medium.copyWith(color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  article.employee!.jobTitle,
                  style: AppStyles.s10.copyWith(color: AppColors.grayText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(width: 12.w),
          ],
          // Text Content on Left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 8.h),
                Text(
                  article.content,
                  style: AppStyles.s12.copyWith(color: AppColors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
