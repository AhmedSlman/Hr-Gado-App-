import 'package:flutter/material.dart';
import 'package:hr_app/features/bottom_navigation/presentation/widget/nav_app.dart';
import 'package:hr_app/features/categories/presentation/views/categories_view.dart';
import 'package:hr_app/features/home/presentation/views/home_view.dart';

class MainPage extends StatefulWidget {
  final int index;

  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  Widget fregmant(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return CategoriesView();
      case 2:
        return Container();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fregmant(_index),
      bottomNavigationBar: NavApp(
        index: _index,
        onSelect: (p0) {
          _index = p0;
          setState(() {});
        },
      ),
    );
  }
}
