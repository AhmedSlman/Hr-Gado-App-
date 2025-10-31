import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/news/data/models/response/news_model.dart';

class EmployeeArticleCard extends StatelessWidget {
  final NewsModel article;
  const EmployeeArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final emp = article.employee!;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(emp.image)),
              SizedBox(height: 8.h),

              Text(emp.name, style: AppStyles.s14Medium),
              Text(emp.jobTitle, style: AppStyles.caption),
            ],
          ),
          SizedBox(width: 28.w),
          Expanded(
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
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
