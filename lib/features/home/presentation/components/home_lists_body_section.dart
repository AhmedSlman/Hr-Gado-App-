import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/app_colors.dart';
import 'package:hr_app/core/theme/app_typography.dart';
import 'package:hr_app/features/home/logic/home_cubit.dart';
import 'package:hr_app/features/home/logic/home_states.dart';
import 'package:hr_app/features/home/presentation/widgets/article_card.dart';
import 'package:hr_app/features/home/presentation/widgets/daily_salary_card.dart';
import 'package:hr_app/features/home/presentation/widgets/meeting_card.dart';
import 'package:hr_app/features/home/presentation/widgets/shimmer_loading_card.dart';

class HomeListsBodySection extends StatelessWidget {
  const HomeListsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        // Loading or Error state - show shimmer
        if (state is HomeScreenLoading || state is HomeScreenError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meetings Shimmer
              _buildSectionTitle('اجتماعات اليوم'),
              SizedBox(height: 12.h),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (_, __) =>
                      ShimmerLoadingCard(width: 200.w, height: 100.h),
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                ),
              ),
              SizedBox(height: 24.h),
              // News Shimmer
              _buildSectionTitle('الاخبار'),
              SizedBox(height: 12.h),
              ShimmerLoadingCard(width: double.infinity, height: 150.h),
              SizedBox(height: 24.h),
              // Salary Shimmer
              _buildSectionTitle('راتب اليوم'),
              SizedBox(height: 12.h),
              ShimmerLoadingCard(width: double.infinity, height: 150.h),
            ],
          );
        }

        // Success state
        if (state is HomeScreenSuccess) {
          final homeData = state.homeScreen.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meetings Section
              if (homeData.todayMeetings.isNotEmpty) ...[
                _buildSectionTitle('اجتماعات اليوم'),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 66.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeData.todayMeetings.length,
                    itemBuilder: (_, index) {
                      return MeetingCard(
                        meeting: homeData.todayMeetings[index],
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // News Section
              if (homeData.articles.isNotEmpty) ...[
                _buildSectionTitle('الاخبار'),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 156.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeData.articles.length,
                    itemBuilder: (_, index) {
                      return ArticleCard(article: homeData.articles[index]);
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // Daily Salary Section
              _buildSectionTitle('راتب اليوم'),
              SizedBox(height: 12.h),
              DailySalaryCard(
                dailySalary: homeData.dailySalary,
                date: homeData.today,
              ),
              SizedBox(height: 24.h),
            ],
          );
        }

        // Initial state or other states
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppStyles.s16Medium.copyWith(color: AppColors.primary),
      textAlign: TextAlign.right,
    );
  }
}
