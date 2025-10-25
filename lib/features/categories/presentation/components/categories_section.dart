import 'package:flutter/material.dart';
import 'package:hr_app/features/categories/data/categories_data.dart';
import 'package:hr_app/features/categories/presentation/widgets/category_card.dart';

class CategoriesGridViewSection extends StatelessWidget {
  const CategoriesGridViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(image: category.icon, title: category.name);
      },
    );
  }
}
