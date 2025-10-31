import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String icon;
  final String route;
  
  final Function(BuildContext)? onTap;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.route,
    this.onTap,
  });
}
