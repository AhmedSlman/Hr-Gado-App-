import 'package:flutter/material.dart';
import 'package:hr_app/features/news/presentation/widgets/employee_article_card.dart';
import 'package:hr_app/features/news/presentation/widgets/general_article_card.dart';

import '../../data/models/response/news_model.dart';

class ArticleCard extends StatelessWidget {
  final NewsModel article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    if (article.isAboutEmployee && article.employee != null) {
      return EmployeeArticleCard(article: article);
    }
    return GeneralArticleCard(article: article);
  }
}
