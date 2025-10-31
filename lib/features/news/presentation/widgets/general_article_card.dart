
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/news/data/models/response/news_model.dart';

class GeneralArticleCard extends StatelessWidget {
  final NewsModel article;
  // ignore: use_key_in_widget_constructors
  const GeneralArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: AppStyles.s14Medium.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 6.h),
          Text(
            article.content,
            style: AppStyles.caption.copyWith(color: AppColors.secondary),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
