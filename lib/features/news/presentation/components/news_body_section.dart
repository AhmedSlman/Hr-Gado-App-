import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/core/utils/user_helper.dart';
import 'package:hr_app/features/meetings/presentation/widgets/add_meeting_button.dart';

import '../../logic/news_cubit.dart';
import '../../logic/news_states.dart';
import '../../router/news_names.dart';
import '../widgets/news_widgets.dart';

class NewsBodySection extends StatelessWidget {
  const NewsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHelper.userRole == 'Manager'
                ? AddButton(
                    title: 'اضافة خبر',
                    onTap: () async {
                      final result = await context.push<bool>(
                        NewsRoutes.addNews,
                      );
                      if (result == true) {
                        NewsCubit.get(context).loadItems();
                      }
                    },
                  )
                : const SizedBox.shrink(),

            SizedBox(height: 12.h),
            BlocBuilder<NewsCubit, NewsStates>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NewsError) {
                  return Center(child: Text(state.message));
                }
                if (state is NewsSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final article = state.articles[index];
                      return ArticleCard(article: article);
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemCount: state.articles.length,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
