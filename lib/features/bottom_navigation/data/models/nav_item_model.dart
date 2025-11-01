import 'package:flutter/material.dart';

class NavItemModel {
  final int index;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const NavItemModel({
    required this.index,
    required this.title,
    required this.icon,
    required this.activeIcon,
  });

  static const List<NavItemModel> items = [
    NavItemModel(
      index: 0,
      title: 'الرئيسية',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItemModel(
      index: 1,
      title: 'الخصائص',
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
    ),
    NavItemModel(
      index: 2,
      title: 'الحساب',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];
}

