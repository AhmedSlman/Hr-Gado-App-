import 'package:flutter/material.dart';
import 'package:hr_app/features/categories/data/categories_data.dart';
import 'package:hr_app/features/categories/presentation/widgets/category_card.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CategoryCard(
              image: category.icon,
              title: category.name,
              route: category.route,
              onTap: category.onTap,
            ),
          );
        },
      ),
    );
  }
}
