import 'package:flutter/material.dart';
import 'package:hr_app/features/account/presentation/views/account_view.dart';
import 'package:hr_app/features/bottom_navigation/presentation/widgets/bottom_nav_bar_widget.dart';
import 'package:hr_app/features/categories/presentation/views/categories_view.dart';
import 'package:hr_app/features/home/presentation/views/home_view.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const CategoriesView();
      case 2:
        return const AccountView();
      default:
        return const HomeView();
    }
  }

  void _handleNavItemSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onItemSelected: _handleNavItemSelected,
      ),
    );
  }
}
